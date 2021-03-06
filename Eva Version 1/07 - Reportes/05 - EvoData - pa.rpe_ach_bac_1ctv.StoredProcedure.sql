IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.rpe_ach_bac_1ctv')
                    AND type IN ( N'P', N'PC' ) )

DROP PROCEDURE [pa].[rpe_ach_bac_1ctv]
GO
/****** Object:  StoredProcedure [pa].[rpe_ach_bac_1ctv]    Script Date: 11/22/2016 2:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [pa].[rpe_ach_bac_1ctv]
	@codcia int,
	@id_cliente_banco varchar(4),
	@num_envio varchar(5) = null
AS
BEGIN

set nocount on

declare @tipo_encabezado varchar(1), @tipo_detalle varchar(1), @caracter_relleno varchar(1),
		@numero_registro int, @anio varchar(4), @mes varchar(2), @dia varchar(2), @concepto varchar(31), @codbca int, @codfpa int

--declare @num_envio varchar(5),
--		@id_cliente_banco varchar(4)

set @tipo_encabezado = 'B'
set @tipo_detalle = 'T'
set @caracter_relleno = SPACE(1)
set @codbca = COALESCE(gen.get_valor_parametro_int('CodigoBancoBAC', 'pa', null, null, null), -1)
set @codfpa = COALESCE(gen.get_valor_parametro_int('CodigoFormaPagoTransferencia', 'pa', null, null, null), -1)

select @anio = CONVERT(VARCHAR, YEAR(GETDATE())),
       @mes = CONVERT(VARCHAR, MONTH(GETDATE())),
       @dia = CONVERT(VARCHAR, DAY(GETDATE())),
       @concepto = 'PRUEBA DE PAGO POR ACH'--(case ppl_frecuencia when 1 then '1A ' when 2 then '2A ' when 2 then '3A ' else '' end) + coalesce(UPPER(gen.nombre_mes(ppl_mes)), '')

--select @id_cliente_banco = coalesce(gen.get_pb_field_data(cia_property_bag_data, 'cia_codigo_cliente_bac'), ''),
--	   @num_envio = coalesce(convert(varchar, gen.get_pb_field_data_int(cia_property_bag_data, 'cia_numero_envio_bac')), '0')
--from eor.cia_companias
--where cia_codigo = @codcia

--update eor.cia_companias
--set cia_property_bag_data = gen.set_pb_field_data(cia_property_bag_data, 'Companias', 'cia_numero_envio_bac', CONVERT(int, @num_envio) + 1)
--where cia_codigo = @codcia

-- Toma el codigo asignado por el banco
set @id_cliente_banco = coalesce(ltrim(rtrim(@id_cliente_banco)), '')
-- Si no se ha especificado un valor de parametro, toma el valor del parametro de aplicacion
--set @id_cliente_banco = (case @id_cliente_banco when '' then COALESCE(gen.get_valor_parametro_int('IdEmpresaClienteBAC', 'pa', null, null, null), -1) else @id_cliente_banco end)
-- Son 4 caracteres rellenados con espacios en blanco a la izquierda
set @id_cliente_banco = RIGHT(REPLICATE(@caracter_relleno, 4) + @id_cliente_banco, 4)

-- Aplica formato al numero de envio
-- Son 5 caracteres rellenados con espacios en blanco a la izquierda
set @num_envio = RIGHT(REPLICATE(@caracter_relleno, 5) + @num_envio, 5)

-- Toma los datos que componen el detalle del pago
;with detalle_ach as (
	select	distinct @tipo_detalle tipo_transaccion,
			@id_cliente_banco numero_cliente,
			@num_envio numero_envio,
			coalesce(cbe_numero_cuenta, '') numero_cuenta,
			row_number() over(order by replace(upper(gen.fn_crufl_sin_tildes(exp_primer_nom + ' ' + exp_primer_ape)), 'Ñ', 'ñ')) numero_linea,
			@anio anio,
			@mes mes,
			@dia dia,
			convert(money, 0.01) neto, -- 13 posiciones
			REPLICATE(@caracter_relleno, 5) cantidad_registros,
			@concepto comentario,
			ltrim(rtrim(replace(upper(gen.fn_crufl_sin_tildes(exp_primer_nom + ' ' + exp_primer_ape)), 'Ñ', 'ñ'))) nombre
	--from sal.NET_NETO_V 
	from exp.emp_empleos
	join eor.plz_plazas on plz_codigo = emp_codplz
	join eor.cia_companias on cia_codigo = plz_codcia
	join exp.exp_expedientes on exp_codigo = emp_codexp								
	join exp.cbe_cuentas_banco_exp on cbe_codexp = exp_codigo 
	join exp.fpe_formas_pago_empleo on fpe_codemp = emp_codigo and fpe_codcbe = cbe_codigo  
	join exp.fpa_formas_pagos on fpa_codigo  = fpe_codfpa
	join gen.bca_bancos_y_acreedores on bca_codigo = cbe_codbca
	where fpe_codfpa = @codfpa
	and cbe_codbca = @codbca
	and emp_estado = 'A'
	group by cbe_numero_cuenta, exp_primer_nom, exp_primer_ape
)

-- Construye las lineas de encabezado y detalle para ser desplegados
select linea
from (
select 0 orden,
	   @tipo_encabezado +
	   RIGHT(REPLICATE(@caracter_relleno, 4) + @id_cliente_banco, 4) +
	   @num_envio +
	   REPLICATE(@caracter_relleno, 20) +
	   REPLICATE(@caracter_relleno, 5) +
	   RIGHT(REPLICATE(@caracter_relleno, 4) + @anio, 4) +
	   RIGHT(REPLICATE(@caracter_relleno, 2) + @mes, 2) +
	   RIGHT(REPLICATE(@caracter_relleno, 2) + @dia, 2) +
	   RIGHT(REPLICATE(@caracter_relleno, 13) + replace(replace(convert(varchar, sum(neto), 1), '.', ''), ',', ''), 13) +
	   RIGHT(REPLICATE(@caracter_relleno, 5) + CONVERT(VARCHAR, COUNT(1)), 5)
	   AS linea
from detalle_ach
union
select numero_linea orden,
	   tipo_transaccion +
	   RIGHT(REPLICATE(@caracter_relleno, 4) + numero_cliente, 4) +
	   numero_envio +
	   LEFT(numero_cuenta + REPLICATE(@caracter_relleno, 20), 20) +
	   RIGHT(REPLICATE(@caracter_relleno, 5) + convert(varchar, numero_linea), 5) +
	   RIGHT(REPLICATE(@caracter_relleno, 4) + anio, 4) +
	   RIGHT(REPLICATE(@caracter_relleno, 2) + mes, 2) +
	   RIGHT(REPLICATE(@caracter_relleno, 2) + dia, 2) +
	   RIGHT(REPLICATE(@caracter_relleno, 13) + replace(replace(convert(varchar, neto, 1), '.', ''), ',', ''), 13) +
	   cantidad_registros +
	   LEFT(comentario + REPLICATE(@caracter_relleno, 31), 31) +
	   LEFT(nombre /*+ REPLICATE(@caracter_relleno, 30)*/, 30) AS linea
from detalle_ach
) datos
order by orden

END

GO
