IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.fn_agrupador_valores_periodo_isr2')
                    AND type IN ( N'TF', N'FN', N'IF' ) ) 
	drop function [pa].[fn_agrupador_valores_periodo_isr2]
/****** Object:  UserDefinedFunction [pa].[fn_agrupador_valores_periodo_isr2]    Script Date: 16-01-2017 11:28:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------------------------------------------------------  
-- Evolution - Panama                                                                         --
-- Obtiene el acumulado de Ingresos y Descuentos de un periodo y agrupador dado               --
------------------------------------------------------------------------------------------------
CREATE  FUNCTION [pa].[fn_agrupador_valores_periodo_isr2]
	(@codcia int, 
    @codemp int,
    @anio int,
    @codtdp int)
RETURNS MONEY
AS

begin
   declare @valor money
   select @valor = sum(inn_valor)
     from (
            select inn_codemp, 
					   case iag_aplicacion
								  when 'Porcentaje' then cast(round(isnull(inn_valor, 0) * (isnull(iag_valor, 0.0) / 100.0), 2) as money)
								  when 'ExcedenteDe' then case when isnull(inn_valor, 0) > isnull(iag_valor, 0) then isnull(inn_valor, 0) - isnull(iag_valor, 0) else 0 end
								  else cast(round(isnull(iag_valor, 0.0), 2) as money) end *
					   case when iag_signo = 1 then
								 1.00
							else  -1.00 end inn_valor,
					   ppl_mes,
					   ppl_anio
				  from sal.inn_ingresos
				  join exp.emp_empleos on emp_codigo = inn_codemp
   				  join sal.ppl_periodos_planilla on inn_codppl = ppl_codigo
   				  join sal.tpl_tipo_planilla on tpl_codigo = ppl_codtpl
				  join sal.iag_ingresos_agrupador on inn_codtig = iag_codtig
				  join sal.agr_agrupadores on agr_codigo = iag_codagr and agr_para_calculo = 1
				 where tpl_codcia = @codcia
               and ppl_anio = @anio
               and iag_codagr = @codtdp
               and ppl_fecha_pago >= emp_fecha_ingreso
               and inn_codemp = @codemp
               and ppl_estado = 'Autorizado'
            union all
            select dss_codemp, 
					   case dag_aplicacion 
								  when 'Porcentaje' then cast(round(isnull(dss_valor, 0) * (isnull(dag_valor, 0.0) / 100.0), 2) as money)
								  when 'ExcedenteDe' then case when isnull(dss_valor, 0) > isnull(dag_valor, 0) then isnull(dss_valor, 0) - isnull(dag_valor, 0) else 0 end
								  else cast(round(isnull(dag_valor, 0.0), 2) as money) end *
					   case when dag_signo = 1 then
								 1.00
							else  -1.00 end inn_valor,
					   ppl_mes,
					   ppl_anio
				  from sal.dss_descuentos
				  join exp.emp_empleos on emp_codigo = dss_codemp
   			   	  join sal.ppl_periodos_planilla on dss_codppl = ppl_codigo
   				  join sal.tpl_tipo_planilla on tpl_codigo = ppl_codtpl
				  join sal.dag_descuentos_agrupador on dss_codtdc = dag_codtdc
				  join sal.agr_agrupadores on agr_codigo = dag_codagr and agr_para_calculo = 1
				 where tpl_codcia = @codcia
               and ppl_anio = @anio
               and dag_codagr = @codtdp
               and ppl_fecha_pago >= emp_fecha_ingreso
               and dss_codemp = @codemp
               and ppl_estado = 'Autorizado'
          ) v1
   
   return isnull(@valor, 0)
end


