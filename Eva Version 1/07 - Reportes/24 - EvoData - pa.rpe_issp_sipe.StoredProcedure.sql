IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.rpe_issp_sipe')
                    AND type IN ( N'P', N'PC' ) )

DROP PROCEDURE [pa].[rpe_issp_sipe]
GO
/****** Object:  StoredProcedure [pa].[rpe_issp_sipe]    Script Date: 11/22/2016 2:39:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [pa].[rpe_issp_sipe]
	@codcia int, @anio int, @mes int, @coduni int = null
AS
SET NOCOUNT ON

-- exec pa.rpe_issp_sipe 1, 2016, 6, null
--set @codcia = 1
--set @anio = 2012
--set @mes = 12

DECLARE @codtag_salario int, @codtag_extras int, @codtag_vacacion int, @codtag_gr int,
        @codtag_bono int, @codtag_xiii int, @codtag_isr int, @codtag_isr_gr int, @codtag_fifty int,
        @codtag_viatico int, @codtag_prest_liq int, @codtag_preaviso int, @codtag_otros int,
        @empresa varchar(150), @nombreMes varchar(10), @codpai varchar(2),
		@codtdo_cedula int, @codtdo_isss int

SELECT @empresa = cia_descripcion, @codpai = cia_codpai
FROM eor.cia_companias
WHERE CIA_CODIGO = @codcia

set @codtag_salario = gen.get_valor_parametro_int('PreelaboradaSIPE_CodigoAgrupador_Salario', @codpai, null, null, null)
set @codtag_extras = gen.get_valor_parametro_int('PreelaboradaSIPE_CodigoAgrupador_Extras', @codpai, null, null, null)
set @codtag_vacacion = gen.get_valor_parametro_int('PreelaboradaSIPE_CodigoAgrupador_Vacacion', @codpai, null, null, null)
set @codtag_gr = gen.get_valor_parametro_int('PreelaboradaSIPE_CodigoAgrupador_GastoRep', @codpai, null, null, null)
set @codtag_bono = gen.get_valor_parametro_int('PreelaboradaSIPE_CodigoAgrupador_Bono', @codpai, null, null, null)
set @codtag_xiii = gen.get_valor_parametro_int('PreelaboradaSIPE_CodigoAgrupador_XIII', @codpai, null, null, null)
set @codtag_isr = gen.get_valor_parametro_int('PreelaboradaSIPE_CodigoAgrupador_ISR', @codpai, null, null, null)
set @codtag_isr_gr = gen.get_valor_parametro_int('PreelaboradaSIPE_CodigoAgrupador_ISR_GR', @codpai, null, null, null)
set @codtag_fifty = gen.get_valor_parametro_int('PreelaboradaSIPE_CodigoAgrupador_Participacion', @codpai, null, null, null)
set @codtag_viatico = gen.get_valor_parametro_int('PreelaboradaSIPE_CodigoAgrupador_Viaticos', @codpai, null, null, null)
set @codtag_prest_liq = gen.get_valor_parametro_int('PreelaboradaSIPE_CodigoAgrupador_Liquidacion', @codpai, null, null, null)
set @codtag_preaviso = gen.get_valor_parametro_int('PreelaboradaSIPE_CodigoAgrupador_Preaviso', @codpai, null, null, null)
set @codtag_otros = gen.get_valor_parametro_int('PreelaboradaSIPE_CodigoAgrupador_OtrosIngresos', @codpai, null, null, null)

SELECT @nombreMes = COALESCE(gen.nombre_mes(@mes), '')

select @codtdo_cedula = gen.get_valor_parametro_int('CodigoDoc_Cedula', @codpai, null, null, null),
	   @codtdo_isss = gen.get_valor_parametro_int('CodigoDoc_SeguroSocial', @codpai, null, null, null)

SELECT @empresa EMPRESA,
       @anio ANIO,
       @nombreMes MES,
       UNI_CODIGO,
       uni_descripcion UNI_NOMBRE,
       EMP_CODIGO,
	   exp_primer_nom + ' ' + exp_primer_ape EMP_NOMBRES_APELLIDOS,
	   COALESCE(cedulas.ide_numero, '') IDE_CIP,
	   COALESCE(seguros_social.ide_numero, '') IDE_ISSS,
	   sal.fn_agrupador_valores_mes(@codcia, EMP_CODIGO, @anio, @mes, @codtag_salario) SALARIO,
	   sal.fn_agrupador_valores_mes(@codcia, EMP_CODIGO, @anio, @mes, @codtag_extras) EXTRAS,
	   sal.fn_agrupador_valores_mes(@codcia, EMP_CODIGO, @anio, @mes, @codtag_vacacion) VACACION,
	   '' INI_VAC, --COALESCE(CONVERT(VARCHAR, dbo.fn_getFechaIniVac(@codcia, @anio, @mes, EMP_CODIGO), 103), '') INI_VAC,
	   '' FIN_VAC, --COALESCE(CONVERT(VARCHAR, dbo.fn_getFechaFinVac(@codcia, @anio, @mes, EMP_CODIGO), 103), '') FIN_VAC,
	   sal.fn_agrupador_valores_mes(@codcia, EMP_CODIGO, @anio, @mes, @codtag_gr) GASTO_REP,
	   sal.fn_agrupador_valores_mes(@codcia, EMP_CODIGO, @anio, @mes, @codtag_bono) BONO,
	   sal.fn_agrupador_valores_mes(@codcia, EMP_CODIGO, @anio, @mes, @codtag_xiii) XIII,
	   abs(sal.fn_agrupador_valores_mes(@codcia, EMP_CODIGO, @anio, @mes, @codtag_isr)) ISR,
	   abs(sal.fn_agrupador_valores_mes(@codcia, EMP_CODIGO, @anio, @mes, @codtag_isr_gr)) ISR_GR,
	   sal.fn_agrupador_valores_mes(@codcia, EMP_CODIGO, @anio, @mes, @codtag_fifty) FIFTY,
	   sal.fn_agrupador_valores_mes(@codcia, EMP_CODIGO, @anio, @mes, @codtag_viatico) VIATICO,
	   sal.fn_agrupador_valores_mes(@codcia, EMP_CODIGO, @anio, @mes, @codtag_prest_liq) PRESTACION_LIQ,
	   sal.fn_agrupador_valores_mes(@codcia, EMP_CODIGO, @anio, @mes, @codtag_preaviso) PREAVISO,
	   sal.fn_agrupador_valores_mes(@codcia, EMP_CODIGO, @anio, @mes, @codtag_otros) OTROS_ING
FROM exp.exp_expedientes
join exp.emp_empleos
on emp_codexp = exp_codigo
LEFT JOIN (
	select ide_codexp, ide_numero
	from exp.ide_documentos_identificacion
	where ide_codtdo = @codtdo_cedula
) cedulas
on cedulas.ide_codexp = exp_codigo
LEFT JOIN (
	select ide_codexp, ide_numero
	from exp.ide_documentos_identificacion
	where ide_codtdo = @codtdo_isss
) seguros_social
on seguros_social.ide_codexp = exp_codigo
JOIN eor.plz_plazas
ON PLZ_CODIGO = EMP_CODPLZ
JOIN eor.uni_unidades
ON UNI_CODIGO = PLZ_CODUNI
WHERE UNI_CODIGO = COALESCE(@coduni, UNI_CODIGO)
AND EXISTS (
    SELECT *
    FROM sal.inn_ingresos
    JOIN sal.ppl_periodos_planilla
    ON ppl_codigo = inn_codppl
	join sal.tpl_tipo_planilla
	on tpl_codigo = ppl_codtpl
    WHERE tpl_codcia = @codcia
    AND ppl_anio = @anio
    AND ppl_mes = @mes
    AND INN_CODEMP = EMP_CODIGO
)
--AND EMP_CODIGO
--IN (SELECT INN_CODEMP
--    FROM PLA_INN_INGRESOS
--    JOIN PLA_PPL_PARAM_PLANI
--    ON PPL_CODCIA = INN_CODCIA
--    AND PPL_CODTPL = INN_CODTPL
--    AND PPL_CODPLA = INN_CODPLA
--    WHERE PPL_CODCIA = @codcia
--    AND PPL_ANIO_CONT = @anio
--    AND PPL_MES_CONT = @mes
--    AND INN_CODEMP = COALESCE(@codemp, INN_CODEMP))
ORDER BY UNI_CODIGO, COALESCE(cedulas.ide_numero, '')

return

GO
