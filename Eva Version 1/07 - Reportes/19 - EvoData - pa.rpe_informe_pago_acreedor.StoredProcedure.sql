IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.rpe_informe_pago_acreedor')
                    AND type IN ( N'P', N'PC' ) )

DROP PROCEDURE [pa].[rpe_informe_pago_acreedor]
GO
/****** Object:  StoredProcedure [pa].[rpe_informe_pago_acreedor]    Script Date: 11/22/2016 2:39:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [pa].[rpe_informe_pago_acreedor]
	@codcia int,
	@anio int,
	@mes int,
	@codfpa int = null,
	@codtcc int = null,
	@codbca int = null,
	@frecuencia_pago varchar(10) = null,
	@frecuencia_planilla int = null,
	@codexp_alternativo varchar(36) = null,
	@codbca_excluir int = null,
	@codtcc_excluir int = null
as
begin
set nocount on

select cia_descripcion,
	   dcc_codbca,
	   dcc_nombre_bca,
	   dcc_ruta,
	   dcc_forma_pago,
	   dcc_frecuencia_pago,
	   dcc_nombre_frecuencia_planilla,
	   dcc_codexp_alternativo,
	   dcc_nombres_apellidos,
	   dcc_referencia,
	   dcc_valor_cobrado
from pa.rep_dcc_descuentos_ciclicos
join eor.cia_companias
on cia_codigo = dcc_codcia
where cia_codigo = @codcia
and dcc_anio = @anio
and dcc_mes = @mes
and dcc_codtcc = isnull(@codtcc, dcc_codtcc)
and dcc_codbca = isnull(@codbca, dcc_codbca)
and dcc_codfpa = isnull(@codfpa, dcc_codfpa)
and dcc_frecuencia_pago = isnull(@frecuencia_pago, dcc_frecuencia_pago)
and dcc_frecuencia_planilla = isnull(@frecuencia_planilla, dcc_frecuencia_planilla)
and dcc_codexp_alternativo = isnull(@codexp_alternativo, dcc_codexp_alternativo)
and dcc_codbca <> (case when @codbca_excluir is null then 0 else @codbca_excluir end)
and dcc_codtcc <> (case when @codtcc_excluir is null then 0 else @codtcc_excluir end)

end

GO
