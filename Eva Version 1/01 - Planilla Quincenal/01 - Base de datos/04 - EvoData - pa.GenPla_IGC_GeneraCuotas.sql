
/****** Object:  StoredProcedure [pa].[GenPla_IGC_GeneraCuotas]    Script Date: 16-01-2017 9:28:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [pa].[GenPla_IGC_GeneraCuotas] (
	@sessionId varchar(36) = null,
    @codppl int,
    @userName varchar(100) = null
) 
as

-- declaracion de variables locales 
declare @codemp int, @codigo int, @codcia int, @codtpl int, 
        @monto_indefinido bit, 
        @proxima_cuota int, @num_cuota int, @cuota real 

declare @fecha_pago datetime, @frecuencia varchar(1),
        @codtig int, @codtpl_quincenal int, @codtpl_vacacion int

-- Obtiene la fecha de finalizacion y la frecuencia del periodo de planilla que va a utilizar 
select @fecha_pago = ppl_fecha_fin, 
       @frecuencia = ppl_frecuencia,
	   @codcia = tpl_codcia,
	   @codtpl = tpl_codigo
  from sal.ppl_periodos_planilla
  join sal.tpl_tipo_planilla on tpl_codigo = ppl_codtpl
 where ppl_codigo = @codppl

-- Obtiene el codigo del tipo de planilla de vacaciones y quincenal  
select @codtpl_quincenal = gen.get_valor_parametro_int('CodigoPlanillaQuincenal', null, null, @codcia, null)  
select @codtpl_vacacion = gen.get_valor_parametro_int('CodigoPlanillaVacacion', null, null, @codcia, null)  

-- Tabla que contiene los codigos de empleos que
-- participan en la planilla que se esta generando
CREATE TABLE #epp_empleo_participa_planilla (
	epp_codemp int
)

INSERT INTO #epp_empleo_participa_planilla
SELECT distinct igc_codemp
FROM sal.igc_ingresos_ciclicos
WHERE (sal.empleado_en_gen_planilla(@sessionId, igc_codemp) = 1)

-- Elimina de la tabla de cuotas las que corresponden a ese periodo de pago 
-- para regenerarlas 
delete from sal.cic_cuotas_ingreso_ciclico
where cic_codppl = @codppl
and cic_codigc in (select igc_codigo from sal.igc_ingresos_ciclicos (nolock) join #epp_empleo_participa_planilla on epp_codemp = igc_codemp)

declare cPRE cursor for 
select IGC_CODEMP,
       IGC_CODIGO,
       IGC_CODTIG,
       IGC_monto_indefinido,
       IGC_proxima_cuota,
       IGC_NUMero_CUOTAs,
       cuota = (case when IGC_saldo < IGC_valor_cuota then IGC_saldo 													  else IGC_valor_cuota end) 
  from sal.igc_ingresos_ciclicos_v
  join #epp_empleo_participa_planilla
  on epp_codemp = igc_codemp
 where --inc_codcia = @codcia
    IGC_CODTPL = CASE WHEN @CODTPL = @codtpl_vacacion THEN @codtpl_quincenal
				     ELSE @codTPL END 
   and igc_activo = 1
   and isnull(IGC_saldo, 9999999999) > 0
   and IGC_valor_cuota <> 0
   and IGC_fecha_INIcio_PAGO <= @fecha_pago 
   --and emp_estado = 'A'
   and (IGC_FRECUENCIA_periodo_pla = @frecuencia -- Frecuencia = esta quincena
     or IGC_FRECUENCIA_periodo_pla = 0 -- Frecuencia = todas las quincenas
   )

open cPRE
WHILE 1 = 1 -- TRUE
BEGIN 
   FETCH NEXT FROM cPRE INTO @codemp, @codigo, @codtig, @monto_indefinido, @proxima_cuota, @num_cuota, @cuota 
   if @@FETCH_STATUS <> 0 break

   -- Inserta un nuevo registro en pla_cic_cuotas_desc 
   If @monto_indefinido = 1 Or @proxima_cuota <= @num_cuota begin 
      if not exists(select 1
                    from sal.cic_cuotas_ingreso_ciclico
                    where cic_codigc = @codigo
                    and cic_numero_cuota = @proxima_cuota)
      begin

			INSERT INTO sal.cic_cuotas_ingreso_ciclico
				   (cic_codigc,cic_numero_cuota,cic_codppl,
					cic_fecha_pago,cic_valor_cuota,
					cic_aplicado_planilla,cic_planilla_autorizada,cic_property_bag_data)
			VALUES
					(@codigo,@proxima_cuota,@codppl,
					 @fecha_pago,@cuota,0,0,null)
      end
   end 
END 

CLOSE cPRE 
DEALLOCATE cPRE 

drop table #epp_empleo_participa_planilla

return
