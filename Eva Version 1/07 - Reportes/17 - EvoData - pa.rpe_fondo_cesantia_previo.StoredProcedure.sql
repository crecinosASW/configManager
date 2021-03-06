IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.rpe_fondo_cesantia_previo')
                    AND type IN ( N'P', N'PC' ) )

DROP PROCEDURE [pa].[rpe_fondo_cesantia_previo]
GO
/****** Object:  StoredProcedure [pa].[rpe_fondo_cesantia_previo]    Script Date: 11/22/2016 2:39:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [pa].[rpe_fondo_cesantia_previo]
    @codcia int,
    @anio int,
    @mes_ini int,
    @mes_fin int
AS

SET NOCOUNT ON
-- execute reporte_fondoces_progreso 1,10,12,2012

declare @trimestre smallint, @porc_prima_ant float, @porc_indem float
declare @codtdo_cedula int, @codtdo_seguro_social int, @codrsa_salario int, @codrsa_gasto_rep int

set @trimestre = @mes_fin / 3

select @codtdo_cedula = coalesce(gen.get_valor_parametro_int('CodigoDoc_Cedula', 'pa', null, null, null), -1),
	   @codtdo_seguro_social = coalesce(gen.get_valor_parametro_int('CodigoDoc_SeguroSocial', 'pa', null, null, null), -1),
	   @codrsa_salario = coalesce(gen.get_valor_parametro_int('CodigoRubroSalario', null, null, @codcia, null), -1),
	   @codrsa_gasto_rep = coalesce(gen.get_valor_parametro_int('CodigoRubroGastoRep', null, null, @codcia, null), -1)

--SELECT @porc_prima_ant = COALESCE(pge_por_provision_prima_antiguedad, 0),
--       @porc_indem = COALESCE(pge_por_provision_indemnizacion, 0)
--FROM PLA_PGE_PARAMETROS_GEN
--WHERE PGE_CODCIA = @codcia

select @porc_prima_ant = coalesce(gen.get_valor_parametro_float('ProvisionPrimaAntiguedad', 'pa', null, null, null), 0),
	   @porc_indem = coalesce(gen.get_valor_parametro_float('ProvisionIndemnizacion', 'pa', null, null, null), 0)

SELECT CODCIA FND_CODCIA,
	   CIADES FND_CIADES,
	   CODEXP_ALTERNATIVO FND_CODEMP,
	   @trimestre FND_TRIMESTRE,
	   @anio FND_ANIO,
	   exp_apellidos_nombres FND_NOMBRE,
	   exp_sexo FND_SEXO,
	   cedulas.ide_numero FND_CIP,
	   seguros_social.ide_numero FND_ISSS,
	   CONVERT(NUMERIC(12,2), gen.fn_edad(emp_fecha_ingreso,getdate())) FND_EDAD,
	   exp_fecha_nac FND_FECHA_NAC,
	   EMP_FECHA_INGRESO FND_FECHA_INGRESO,
	   FECHA_RETIRO FND_FECHA_RETIRO,
	   CONVERT(NUMERIC(12,2), salarios.ese_valor_hora) FND_SALARIO_HORA,
	   COALESCE(salarios.ese_valor, 0) + COALESCE(gastos_rep.ese_valor, 0) FND_SALARIO_MENSUAL,
	   ACUMULADO FND_SALARIO_TRIMESTRE,
	   MES1 FND_SALARIO_MES1,
	   MES2 FND_SALARIO_MES2,
	   MES3 FND_SALARIO_MES3,
	   CONVERT(NUMERIC(12,2), ACUMULADO * @porc_prima_ant / 100.00) FND_PA_TRIMESTRE,
	   CONVERT(NUMERIC(12,2), ACUMULADO * @porc_indem / 100.00) FND_INDM_TRIMESTRE,
	   CONVERT(NUMERIC(12,2), ACUMULADO * @porc_prima_ant / 100.00) +
	   CONVERT(NUMERIC(12,2), ACUMULADO * @porc_indem / 100.00) FND_TOT_APORTADO
FROM pa.fn_ingresos_fondo_cesantia(@codcia, null, @anio, @mes_ini, @mes_fin)
join exp.exp_expedientes
on exp_codigo = CODEXP
left join (
	select ide_codexp, ide_numero
	from exp.ide_documentos_identificacion
	where ide_codtdo = @codtdo_cedula
) cedulas
on cedulas.ide_codexp = exp_codigo
left join (
	select ide_codexp, ide_numero
	from exp.ide_documentos_identificacion
	where ide_codtdo = @codtdo_seguro_social
) seguros_social
on seguros_social.ide_codexp = exp_codigo
join exp.emp_empleos
on emp_codexp = exp_codigo
join exp.ese_estructura_sal_empleos salarios
on salarios.ese_codemp = emp_codigo
and salarios.ese_codrsa = @codrsa_salario
and salarios.ese_estado = 'V'
left join exp.ese_estructura_sal_empleos gastos_rep
on gastos_rep.ese_codemp = emp_codigo
and gastos_rep.ese_codrsa = @codrsa_gasto_rep
and gastos_rep.ese_estado = 'V'
   
RETURN

GO
