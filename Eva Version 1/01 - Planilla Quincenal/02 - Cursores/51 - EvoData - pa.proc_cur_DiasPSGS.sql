/****** Object:  StoredProcedure [pa].[proc_cur_DiasPSGS]    Script Date: 11/22/2016 2:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [pa].[proc_cur_DiasPSGS]
	@codcia int, @codtpl int, @codppl int
as
begin

set language english

declare @fecha_ini datetime, @fecha_fin datetime

--set @codcia = 1--$$CODCIA$$
--set @codtpl = 1--$$CODTPL$$
--set @codppl = 1014--$$CODPPL$$

-- select * from sal.ppl_periodos_planilla where ppl_codtpl = 1 and ppl_codigo_planilla = '20160901'

SELECT @fecha_ini = PPL_FECHA_INI, @fecha_fin = PPL_FECHA_FIN
FROM sal.ppl_periodos_planilla
JOIN sal.tpl_tipo_planilla on tpl_codigo = ppl_codtpl
WHERE tpl_codcia = @codcia
AND PPL_CODTPL = @codtpl
AND ppl_codigo = @codppl

SELECT txi_codcia CODCIA,
	   IXE_CODEMP CODEMP,
	   DATEDIFF(DD, (CASE WHEN IXE_INICIO <= @fecha_ini THEN @fecha_ini ELSE IXE_INICIO END), (CASE WHEN IXE_FINAL >= @fecha_fin THEN @fecha_fin ELSE IXE_FINAL END)) + 1 DIAS,
	   sal.fn_total_horas_laborales_periodo(1, ixe_codemp, @fecha_ini, dateadd(dd, -1, ixe_inicio)) HORAS
FROM acc.ixe_incapacidades
JOIN acc.txi_tipos_incapacidad ON txi_codigo = ixe_codtxi
JOIN acc.rin_riesgos_incapacidades on rin_codigo = ixe_codrin 
WHERE rin_utiliza_fondo = 0 /*Toma los tipos de riesgos de incapacidad que no afectan el fondo de incapacidad*/
AND txi_codcia = @codcia
AND ((IXE_INICIO >= @fecha_ini AND IXE_INICIO <= @fecha_fin) /* Incapacidad inicia en esta planilla */
 OR (IXE_FINAL >= @fecha_ini AND IXE_FINAL <= @fecha_fin) /* Incapacidad finaliza en esta planilla */
 OR ((@fecha_ini >= IXE_INICIO AND @fecha_ini <= IXE_FINAL) AND (@fecha_fin >= IXE_INICIO AND @fecha_fin <= IXE_FINAL)) /* Incapacidad en curso */
 )
 
 end
GO
