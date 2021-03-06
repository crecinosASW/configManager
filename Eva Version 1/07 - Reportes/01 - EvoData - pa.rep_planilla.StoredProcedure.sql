IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.rep_planilla')
                    AND type IN ( N'P', N'PC' ) )

DROP PROCEDURE [pa].[rep_planilla]
GO
/****** Object:  StoredProcedure [pa].[rep_planilla]    Script Date: 11/22/2016 2:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- pa.rep_planilla 1,'1','20160901', 'C'
CREATE PROCEDURE [pa].[rep_planilla](
	@codcia int = null,
    @codtpl varchar(20) = null,
    @codpla varchar(20) = null,
	@tipo_grupo varchar(1) = null,
	@codfpa int = null
)
as
set nocount on 
/*
Declare @codcia int,
        @codtpl varchar(20),
        @codpla varchar(20)

set @codcia = 18
set @codtpl  = '1'
set @codpla = '20140115'
*/        

declare @codppl int, @fecha_inicio datetime, @fecha_fin datetime

select @codppl = ppl_codigo,
       @fecha_inicio = ppl_fecha_ini,
       @fecha_fin = ppl_fecha_fin
  from sal.ppl_periodos_planilla
  join sal.tpl_tipo_planilla
    on tpl_codigo = ppl_Codtpl
 where tpl_codcia = @codcia
   and tpl_codigo_visual = @codtpl
   and ppl_codigo_planilla = @codpla


declare @codagr_salario int,
        @codagr_gtorep int,
        @codagr_incap int,
        @codagr_comision int,
        @codagr_extra int,
		@codagr_tnt int,
        @codagr_isr int,
        @codagr_isrgto int,
        @codagr_segurosocial int,
        @codagr_seguroeducativo int

select @codagr_salario = agr_codigo from sal.agr_Agrupadores where agr_abreviatura = 'ING - SALARIO' and agr_codpai = 'pa'
select @codagr_gtorep = agr_codigo from sal.agr_Agrupadores where agr_abreviatura = 'ING - GTOREP' and agr_codpai = 'pa'
select @codagr_incap = agr_codigo from sal.agr_Agrupadores where agr_abreviatura = 'ING - INCAP' and agr_codpai = 'pa'
select @codagr_comision = agr_codigo from sal.agr_Agrupadores where agr_abreviatura = 'ING - COMPENSATORIO' and agr_codpai = 'pa'
select @codagr_extra = agr_codigo from sal.agr_Agrupadores where agr_abreviatura = 'ING - EXTRA' and agr_codpai = 'pa'
select @codagr_tnt = agr_codigo from sal.agr_Agrupadores where agr_abreviatura = 'DED - TNT' and agr_codpai = 'pa'
select @codagr_isr = agr_codigo from sal.agr_Agrupadores where agr_abreviatura = 'DED - ISR' and agr_codpai = 'pa'
select @codagr_isrgto = agr_codigo from sal.agr_Agrupadores where agr_abreviatura = 'DED - ISRGTO' and agr_codpai = 'pa'
select @codagr_segurosocial = agr_codigo from sal.agr_Agrupadores where agr_abreviatura = 'DED - SEGUROSOCIAL' and agr_codpai = 'pa'
select @codagr_seguroeducativo = agr_codigo from sal.agr_Agrupadores where agr_abreviatura = 'DED - SEGUROEDUCATIVO' and agr_codpai = 'pa';


with inn as (
select inn_Codemp, 
       case when exists(select null 
                        from sal.iag_ingresos_agrupador 
                        where iag_codagr = @codagr_salario and iag_codtig = inn_codtig)
            then inn_valor 
            else 0
         end salario,
       case when exists(select null 
                            from sal.iag_ingresos_agrupador 
                            where iag_codagr = @codagr_gtorep and iag_codtig = inn_codtig)
            then inn_valor 
            else 0
         end gtorep,
        case when exists(select null 
                            from sal.iag_ingresos_agrupador 
                            where iag_codagr = @codagr_incap and iag_codtig = inn_codtig)
            then inn_valor 
            else 0
         end incap,
        case when exists(select null 
                            from sal.iag_ingresos_agrupador 
                            where iag_codagr = @codagr_extra and iag_codtig = inn_codtig)
            then inn_valor 
            else 0
         end extra,
        case when exists(select null 
                           from sal.iag_ingresos_agrupador 
                          where iag_codagr = @codagr_comision and iag_codtig = inn_codtig)
            then inn_valor 
            else 0
         end comision,
        case when inn_codtig not in (select iag_codtig
                                       from sal.iag_ingresos_agrupador 
                                      where iag_codagr in  (@codagr_comision, @codagr_extra, @codagr_incap,
                                                        @codagr_gtorep,@codagr_salario)
                                    )
            then inn_valor 
            else 0
         end otrosingresos
  from sal.inn_ingresos 
 where inn_codppl = @codppl
), dss as(
select dss_codemp,sum(tnt) tnt,sum(isr) isr, sum(isrgto) isrgto,
		sum(segurosocial) segurosocial, sum(seguroeducativo) seguroeducativo,
		sum(otrosdescuentos) otrosdescuentos
from( 
	select dss_codemp, 
       case when exists(select null 
                           from sal.dag_descuentos_agrupador
                          where dag_codagr = @codagr_tnt and dag_codtdc = dss_codtdc)
            then dss_valor
            else 0
         end tnt,
       case when exists(select null 
                           from sal.dag_descuentos_agrupador
                          where dag_codagr = @codagr_isr and dag_codtdc = dss_codtdc)
            then dss_valor
            else 0
         end isr,
        case when exists(select null 
                           from sal.dag_descuentos_agrupador
                          where dag_codagr = @codagr_isrgto and dag_codtdc = dss_codtdc)
            then dss_valor
            else 0
         end isrgto,
        case when exists(select null 
                           from sal.dag_descuentos_agrupador
                          where dag_codagr = @codagr_segurosocial and dag_codtdc = dss_codtdc)
            then dss_valor
            else 0
         end segurosocial,
        case when exists(select null 
                           from sal.dag_descuentos_agrupador
                          where dag_codagr = @codagr_seguroeducativo and dag_codtdc = dss_codtdc)
            then dss_valor
            else 0
         end seguroeducativo,
       case when dss_codtdc not in (select dag_codtdc
                                       from sal.dag_descuentos_Agrupador
                                      where dag_codagr in  (@codagr_seguroeducativo, @codagr_segurosocial, @codagr_isrgto,
                                                        @codagr_isr, @codagr_tnt)
                                    )
            then dss_valor 
            else 0
         end otrosdescuentos
  from sal.dss_descuentos 
  where dss_codppl = @codppl  
  -- esto se agrego en el caso que no tengan descuentos
  union all
  select distinct inn_codemp dss_codemp,
  0.00 TNT,0.00 ISR, 0.00 isrgto, 0.00 segurosocial,
  0.00 seguroeducativo, 0.00 otrosdescuentos
  from sal.inn_ingresos
  where inn_codppl = @codppl  
  )V1
  group by dss_Codemp

)

select (select cia_Descripcion from eor.cia_companias where cia_codigo = @codcia) empresa,
       @fecha_inicio desde,
       @fecha_fin hasta,
       hpa_nombre_tipo_planilla tipoplanilla,
       hpa_fecha_ingreso fechaingreso,
       hpa_codemp , 
       (case @tipo_grupo when 'U' then hpa_nombre_unidad when 'C' then (case isnull(hpa_cco_nomenclatura_contable, '') when '' then '' else isnull(hpa_cco_nomenclatura_contable, '') + ' - ' end) + hpa_nombre_centro_costo end) unidad,
       hpa_nombre_puesto puesto,
       hpa_apellidos_nombres nombre,
	   (case isnumeric(exp_codigo_alternativo) when 0 then 0 else convert(numeric, exp_codigo_alternativo) end) codexp_alternativo,
       inn.*,
       dss.*,
       totalingresos - isnull(totaldescuentos,0) neto,
	   (case @tipo_grupo when 'U' then 0 when 'C' then (case when ISNUMERIC(hpa_cco_nomenclatura_contable) = 1 then convert(numeric, hpa_cco_nomenclatura_contable) else 0 end) else 0 end) criterio_orden
	   , (case isnull(@codfpa, 0) when 0 then '' else fpa_descripcion end) forma_pago
  from sal.hpa_hist_periodos_planilla
  join exp.emp_empleos on emp_codigo = hpa_codemp
  join exp.exp_expedientes on exp_codigo = emp_codexp
  left join exp.fpe_formas_pago_empleo on fpe_codemp = emp_codigo
  left join exp.fpa_formas_pagos on fpa_codigo = fpe_codfpa
  left join (
          select inn_codemp, 
               sum(salario) salario,
               sum(gtorep) gtorep,
               sum(incap) incap,
               sum(extra) extra,
               sum(comision) comision,
               sum(otrosingresos) otrosingresos,
               sum(salario)+ 
               sum(gtorep) +
               sum(incap) +
               sum(extra) +
               sum(comision) +
               sum(otrosingresos) -
			   isnull((select isnull(sum(isnull(tnt, 0)), 0) from dss where dss_codemp = inn_codemp), 0)
			   as totalingresos
          from  inn
		  group by inn_codemp

        )inn on inn_codemp  = hpa_codemp
   left join (
          select Dss_codemp, 
               sum(tnt) tnt,
			   sum(isr) isr,
               sum(isrgto) isrgto,
               sum(segurosocial) segurosocial,
               sum(seguroeducativo) seguroeducativo,
               sum(otrosdescuentos) otrosdescuentos,
               sum(isr) +
               sum(isrgto)+
               sum(segurosocial) +
               sum(seguroeducativo) +
               sum(otrosdescuentos) totaldescuentos
          from  dss
          group by dss_codemp

        )dss on dss_codemp  = hpa_codemp
 where hpa_codppl = @codppl
 and fpe_codfpa = isnull(@codfpa, fpe_codfpa)
 order by criterio_orden, unidad, codexp_alternativo, nombre

GO
