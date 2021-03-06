IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.rpe_archivo_sipe')
                    AND type IN ( N'P', N'PC' ) )

DROP PROCEDURE [pa].[rpe_archivo_sipe]
GO
/****** Object:  StoredProcedure [pa].[rpe_archivo_sipe]    Script Date: 11/22/2016 2:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [pa].[rpe_archivo_sipe]
	@codcia int,
	@anio int,
	@mes int
as
begin
set nocount on
-- exec pa.rpe_archivo_sipe 1, 2016, 7
--declare
--	@codcia int,
--	@anio int,
--	@mes int

--select @codcia = 1, @anio = 2014, @mes = 1

declare @codtdo_isss int,
		@codtdo_cip int,
		@codtdo_pasaporte int,
		@total_devengado numeric(12,2),
		@total_renta numeric(12,2),
		@total_X int,
		@cuenta_X int,
		@total_decimo numeric(12,2),
		@correlativo_isss varchar(10),
		@numero_patronal varchar(20),
		@codpai varchar(2),
		@codtag_extras int, @codtag_vacacion int

set @total_decimo = 0.00

select @codtdo_cip = gen.get_valor_parametro_varchar('CodigoDoc_Cedula','pa',null,null,null),
	   @codtdo_isss = gen.get_valor_parametro_varchar('CodigoDoc_SeguroSocial','pa',null,null,null),
	   @codtdo_pasaporte = gen.get_valor_parametro_varchar('CodigoDoc_Pasaporte','pa',null,null,null)

select @total_devengado = coalesce(sum(coalesce((case iss_es_decimo when 1 then 0 else iss_devengado end), 0)), 0),
	   @total_renta = coalesce(sum(coalesce(iss_renta, 0)), 0),
	   @total_X = coalesce(sum(convert(numeric, iss_codigo_rubro)), 0),
	   @cuenta_X = coalesce(sum((case when iss_devengado < 235 and iss_codigo_rubro = '03' and iss_es_decimo = 0 then 1 else 0 end)), 0)
from pa.vw_iss_seguro
join exp.emp_empleos
on emp_codigo = iss_codemp
join pa.vw_identificacion_expediente
on codexp = emp_codexp
where iss_codcia = @codcia
and iss_anio = @anio
and iss_mes = @mes
and isnull(cip_sipe, '') <> ''
and iss_devengado > 0
and emp_codexp not in (2118)

select @correlativo_isss = gen.lpad(coalesce(gen.get_pb_field_data(cia_property_bag_data, 'cia_correlativo_css'), ''), 5, '0'),
	   @numero_patronal = replace(ltrim(rtrim(isnull(cia_patronal, ''))), '-', ''),
	   @codpai = cia_codpai
from eor.cia_companias
where cia_codigo = @codcia

-- select @total_devengado total_devengado, @total_renta total_renta, @total_X total_X, @cuenta_X cuenta_X

SELECT	REG + COALESCE(CORRELATIVO, '') + COALESCE(NO_PLANILLA, 'SIN_CODIGO_EMPLEADO') +
		COALESCE(NO_ISSS, '') + COALESCE(PROV_CED, 'SIN_CEDULA') + 
		COALESCE(replace(EMP_PRIMER_APE, 'Ñ', 'N'), 'SIN_PRIMER_APELLIDO') + COALESCE(EMP_PRIMER_NOM, 'SIN_PRIMER_NOMBRE') + COALESCE(SEXO, 'SIN_SEXO') +
		COALESCE(ISS_CODIGO_RUBRO, 'SIN_CODIGO_RUBRO') + COALESCE(AGENCIA, 'SIN_AGENCIA') + COALESCE(DIAS, 'SIN_DIAS') + 
		COALESCE(ISS_DEVENGADO, 'SIN_DEVENGADO') + COALESCE(RENTA, 'SIN_RENTA') + COALESCE(CLASIF_RENTA, 'SIN_CLASE_RENTA') + 
		SPACE(2) + '000' + SPACE(15) + COALESCE(PASAPORTE, 'SIN_PASAPORTE')
		AS LINEA_SYSMECA
		, 1 ORDEN
from (
	select reg,
		   correlativo,
		   codemp no_planilla,
		   gen.lpad(replace(ltrim(rtrim(isnull(iss_isss, ''))), '-', ''), 7, '0') no_isss,
		   right(SPACE(15) + case gen.fn_contar_caracteres(iss_cip,'-') 
					when 2 then
							(case 
								when gen.fn_esLetra(SUBSTRING(gen.fn_get_token(iss_cip,'-',1), 1, 1)) +
									 gen.fn_esLetra(SUBSTRING(gen.fn_get_token(iss_cip,'-',1), 2, 1)) > 0
								then gen.lpad(gen.fn_get_token(iss_cip,'-',1),2,'0')
								else gen.lpad(convert(varchar, CONVERT(numeric, gen.fn_get_token(iss_cip,'-',1))), 2, '0')
							 end)
							 + 
						space(2) + 
						gen.lpad(gen.fn_get_token(iss_cip,'-',2),5,'0') +
						gen.lpad(gen.fn_get_token(iss_cip,'-',3),6,'0') 
					when 3 then
						gen.lpad(gen.fn_get_token(iss_cip,'-',1),2,'0') + 
						gen.lpad(gen.fn_get_token(iss_cip,'-',2),2,space(1)) + 
						gen.lpad(gen.fn_get_token(iss_cip,'-',3),5,'0') + 
						gen.lpad(gen.fn_get_token(iss_cip,'-',4),6,'0')
					when 1 then
						(case when ascii(right(gen.fn_get_token(iss_cip,'-',1), 1)) >= 48 
								   and ascii(right(gen.fn_get_token(iss_cip,'-',1), 1)) <= 57
								then gen.lpad(gen.fn_get_token(iss_cip,'-',1),2,'0') + space(2)
								else space(2) + gen.rpad(gen.fn_get_token(iss_cip,'-',1),2,space(1))
								end) +
							gen.lpad(gen.fn_get_token(iss_cip,'-',2),11,'0') 
					else
						isnull(iss_cip,'')
				end
			   , 15)  -- Cédula, LONG.MAX = 15
			prov_ced,
			emp_primer_ape,
			emp_primer_nom,
			emp_sexo sexo,
			tc iss_codigo_rubro,
			SPACE(2) agencia,
			gen.lpad(convert(varchar, pa.fn_get_dias_incap(codemp, @mes, @anio)), 2, '0') dias,
			gen.lpad(replace(convert(varchar, convert(numeric(12,2), iss_devengado)), '.', ''), 7, '0') iss_devengado,
			gen.lpad(replace(convert(varchar, convert(numeric(12,2), renta)), '.', ''), 7, '0') renta,
			clave clasif_renta,
			pas pasaporte
	from (
		select '2' REG,
			   gen.lpad(coalesce(gen.get_pb_field_data(cia_property_bag_data, 'cia_correlativo_css'), ''), 5, '0') correlativo,
			   gen.lpad(convert(varchar, coalesce(exp_codigo_alternativo, '')), 5, '0') codemp,
			   --coalesce((select top 1 coalesce(ide_numero, '') from exp.ide_documentos_identificacion where ide_codexp = exp_codigo and ide_codtdo = @codtdo_isss), '') iss_isss,
			   isss_sipe iss_isss,
			   coalesce(gen.get_pb_field_data(cia_property_bag_data, 'cia_licencia'), '') iss_licencia,
			   tem_descripcion iss_sector,
			   coalesce(rep_cip, '') iss_persNatu,
			   coalesce(gen.get_pb_field_data(cia_property_bag_data, 'cia_ruc'), '') iss_persJuri,
			   cia_direccion iss_direccion,
			   cia_telefonos iss_telefonos,
			   coalesce(rep_nombre, '') iss_representante,
			   cia_patronal iss_patronal,
			   iss_mes,
			   iss_anio,
			   gen.lpad(convert(varchar, exp_codigo_alternativo), 5, '0') iss_codemp,
			   --replace(coalesce((select top 1 coalesce(ide_numero, '') from exp.ide_documentos_identificacion where ide_codexp = exp_codigo and ide_codtdo = @codtdo_cip), ''), '-', '') iss_cip,
			   cip_sipe iss_cip,
			   iss_observaciones,
			   iss_otros otros,
			   iss_devengado,
				gen.rpad(replace(upper(substring(RTRIM(gen.fn_quitar_caracteres_especiales(isnull(exp_primer_ape,''))),1,20)), '  ', ' '),14,' ')
				emp_primer_ape,
				gen.rpad(replace(upper(substring(RTRIM(gen.fn_quitar_caracteres_especiales(isnull(exp_primer_nom,''))),1,20)), '  ', ' '),14,' ')
				emp_primer_nom,
			   isnull(exp_sexo, space(1)) emp_sexo,
			   (case coalesce(exp_codpai_nacimiento, '') when 'pa' then '' else 'P' end) pas,
			   isnull(iss_codigo_rubro, '00') tc,
			   '' dp,
			   iss_renta +
					   coalesce(
					   (select coalesce(Si.iss_renta, 0)
						from pa.vw_iss_seguro Si
						where Si.iss_codcia = Se.iss_codcia
						and Si.iss_anio = Se.iss_anio
						and Si.iss_mes = Se.iss_mes
						and Si.iss_codemp = Se.iss_codemp
						and Si.iss_codigo_rubro = Se.iss_codigo_rubro
						and Si.iss_codigo_rubro <> '73'
						and Si.iss_es_decimo = (case iss_codigo_rubro when '03' then 1 else 0 end)), 0.00)
			   renta,
			   (case iss_codigo_rubro
				when '73'
				then iss_renta +
					   coalesce(
					   (select coalesce(Si.iss_renta, 0)
						from pa.vw_iss_seguro Si
						where Si.iss_codcia = Se.iss_codcia
						and Si.iss_anio = Se.iss_anio
						and Si.iss_mes = Se.iss_mes
						and Si.iss_codemp = Se.iss_codemp
						and Si.iss_codigo_rubro = Se.iss_codigo_rubro
						and Si.iss_es_decimo = 1), 0.00)
				else 0.00 end)
			   renta_gr,
			   coalesce(gen.get_pb_field_data(exp_property_bag_data, 'exp_clase_renta'), 'A') + coalesce(gen.get_pb_field_data(exp_property_bag_data, 'exp_numero_dependientes'), '0') clave,
			   coalesce(
			   (select coalesce(Si.iss_devengado, 0)
				from pa.vw_iss_seguro Si
				where Si.iss_codcia = Se.iss_codcia
				and Si.iss_anio = Se.iss_anio
				and Si.iss_mes = Se.iss_mes
				and Si.iss_codemp = Se.iss_codemp
				and Si.iss_codigo_rubro = Se.iss_codigo_rubro
				and Si.iss_es_decimo = 1), 0.00)
			   decimo
		from pa.vw_iss_seguro Se
		join exp.emp_empleos
		on emp_codigo = iss_codemp
		join exp.exp_expedientes
		on exp_codigo = emp_codexp
		join eor.cia_companias
		on cia_codigo = iss_codcia
		left join eor.tem_tipos_empresas
		on tem_codigo = cia_codtem
		left join eor.plz_plazas
		on plz_codigo = emp_codplz
		left join eor.cdt_centros_de_trabajo
		on cdt_codigo = plz_codcdt
		left join (
			select rep_codcia, exp_nombres_apellidos rep_nombre, isnull(ide_cip.ide_numero, ide_pasaporte.ide_numero) rep_cip
			from eor.rep_representantes_legales
			join exp.exp_expedientes
			on exp_codigo = rep_codexp
			left join exp.ide_documentos_identificacion ide_cip
			on ide_cip.ide_codexp = exp_codigo
			and ide_cip.ide_codtdo = @codtdo_cip
			left join exp.ide_documentos_identificacion ide_pasaporte
			on ide_pasaporte.ide_codexp = exp_codigo
			and ide_pasaporte.ide_codtdo = @codtdo_pasaporte
		) rep
		on rep_codcia = cia_codigo
		left join pa.vw_identificacion_expediente
		on codexp = exp_codigo
		where iss_es_decimo = 0
		and iss_codcia = @codcia
		and iss_anio = @anio
		and iss_mes = @mes
		and isss_sipe <> ''
		and iss_devengado > 0
		and emp_codigo not in (2118)
	) V
	where iss_devengado > 0
) W
union
SELECT	'0' + @correlativo_isss + '00000000000' + RIGHT('0000000000' + REPLACE(@total_devengado, '.', ''), 10) +
		'000000' + RIGHT('0000000000' + REPLACE(@total_renta, '.', ''), 10) + RIGHT('000000' + REPLACE(@total_X, '.', ''), 6) + 
		RIGHT('0000000000' + REPLACE(@total_decimo, '.', ''), 10) + SPACE(7) + RIGHT('0000' + CONVERT(VARCHAR, @cuenta_X), 4) + 
		@numero_patronal + LEFT(UPPER(gen.fn_crufl_NombreMes(@mes)) + SPACE(10), 10) + CONVERT(VARCHAR, @anio), 2 ORDEN
order by ORDEN

end

GO
