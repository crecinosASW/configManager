IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.rpe_ach_banco_general')
                    AND type IN ( N'P', N'PC' ) )

DROP PROCEDURE [pa].[rpe_ach_banco_general]
GO
/****** Object:  StoredProcedure [pa].[rpe_ach_banco_general]    Script Date: 11/22/2016 2:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [pa].[rpe_ach_banco_general]
	@codcia int, @codtpl varchar(20), @codpla varchar(20)
AS
BEGIN
--set @codcia = 1
--set @codtpl = '1'
--set @codpla = '201501'


set nocount on

declare @codppl int, @concepto varchar(80)

select @codppl = ppl_codigo,
		@concepto = convert(varchar(80), 'Pago ' + tpl_descripcion + ' ' + (case ppl_frecuencia when 1 then '1a' else '' end) + ' ' + gen.fn_crufl_NombreMes(ppl_mes) + ' ' + CONVERT(varchar, ppl_anio))
from sal.ppl_periodos_planilla
join sal.tpl_tipo_planilla
on tpl_codigo = ppl_codtpl
where tpl_codcia = @codcia
and tpl_codigo_visual = @codtpl
and ppl_codigo_planilla = @codpla

declare @codtdo_cedula int, @codtdo_pasaporte int, @codfpa_ach int

select @codtdo_cedula = apa_valor
from gen.apa_alcances_parametros
where apa_codpar = 'CodigoDoc_Cedula'
and apa_codpai = 'pa'

select @codtdo_pasaporte = apa_valor
from gen.apa_alcances_parametros
where apa_codpar = 'CodigoDoc_Pasaporte'
and apa_codpai = 'pa'

set @codfpa_ach = COALESCE(gen.get_valor_parametro_int('CodigoFormaPagoTransferencia', 'pa', null, null, null), -1)

--select gen.rpad(cip, 15, SPACE(1)) +
--	   gen.rpad(nombre, 22, SPACE(1)) +
--	   gen.lpad(ruta, 9, space(1)) +
--	   gen.lpad(cbe_numero_cuenta, 17, SPACE(1)) +
--	   gen.lpad(cbe_tipo_cuenta, 2, space(1)) +
--	   gen.lpad(monto, 11, SPACE(1)) +
--	   tipo_pago +
--	   gen.rpad(referencia, 80, SPACE(1))
select cip + char(9) +
	   nombre + char(9) +
	   convert(varchar, ruta) + char(9) +
	   cbe_numero_cuenta + char(9) +
	   convert(varchar, cbe_tipo_cuenta) + char(9) +
	   convert(varchar, monto) + char(9) +
	   tipo_pago + char(9) +
	   referencia
from (
	select exp_codigo codexp,
		   coalesce(ide_cip, coalesce(ide_pasaporte, '')) cip,
		   replace(replace(replace(replace(replace(replace(replace(upper(coalesce(ltrim(rtrim(exp_primer_nom)), '') + ' ' + coalesce(ltrim(rtrim(exp_primer_ape)), '')), 'Á', 'A'), 'É', 'E'), 'Í', 'I'), 'Ó', 'O'), 'Ú', 'U'), 'Ñ', 'N'), '-', ' ')
		   nombre,
		   coalesce(bca_ruta, '') ruta,
		   coalesce(cbe_numero_cuenta, '') cbe_numero_cuenta,
		   coalesce(cbe_tipo_cuenta, '') cbe_tipo_cuenta,
		   coalesce(net_neto, 0) monto,
		   'C' tipo_pago,
		   'REF*TXT**' + @concepto + ' \' referencia
		   
	from exp.exp_expedientes
	left join ( -- Recupera los numeros de cedula de los expedientes de los colaboradores
		select ide_codexp, max(ltrim(rtrim(coalesce(ide_numero, '')))) ide_cip
		from exp.ide_documentos_identificacion
		where ide_codtdo = @codtdo_cedula
		group by ide_codexp
	) cedulas
	on cedulas.ide_codexp = exp_codigo
	left join ( -- Recupera los numeros de pasaporte de los expedientes de los colaboradores
		select ide_codexp, max(ltrim(rtrim(coalesce(ide_numero, '')))) ide_pasaporte
		from exp.ide_documentos_identificacion
		where ide_codtdo = @codtdo_pasaporte
		group by ide_codexp
	) pasaportes
	on pasaportes.ide_codexp = exp_codigo
	join (-- Este deberia ser un JOIN sin el LEFT para que incluya solo los que tienen pago por Banco General
			   -- Recupera los numeros de cuenta que han sido configuradas como formas de pago por ACH para el Banco General
		select cbe_codexp,
			   cbe_codbca,
			   ltrim(rtrim(coalesce(cbe_numero_cuenta, ''))) cbe_numero_cuenta,
			   (case coalesce(cbe_tipo_cuenta, '') when 'A' then '04' when 'C' then '03' else 'XX' end) cbe_tipo_cuenta
		from exp.cbe_cuentas_banco_exp
		join exp.fpe_formas_pago_empleo
		on fpe_codcbe = cbe_codigo
		join exp.emp_empleos
		on emp_codigo = fpe_codemp
		where fpe_codfpa = @codfpa_ach
		and emp_estado = 'A'
	) cuentas
	on cbe_codexp = exp_codigo
	join (
		select bca_codigo, gen.get_pb_field_data(bca_property_bag_data, 'bca_ruta') bca_ruta
		from gen.bca_bancos_y_acreedores
	) bancos
	on bca_codigo = cbe_codbca
	join ( -- Recupera los montos netos devengados por el colaborador en la planilla para la cual se genera el ACH
		select net_codexp,
			   convert(numeric(12,2), SUM((case net_tipo when 'D' then net_valor * -1 else net_valor end))) net_neto
		from sal.net_neto_v
		where net_codppl = @codppl
		group by net_codexp	
	) netos
	on net_codexp = exp_codigo
	where net_neto > 0
) V

END

GO
