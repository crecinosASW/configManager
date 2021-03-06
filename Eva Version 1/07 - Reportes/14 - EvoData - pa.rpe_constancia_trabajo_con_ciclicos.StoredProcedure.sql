IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.rpe_constancia_trabajo_con_ciclicos')
                    AND type IN ( N'P', N'PC' ) )

DROP PROCEDURE [pa].[rpe_constancia_trabajo_con_ciclicos]
GO
/****** Object:  StoredProcedure [pa].[rpe_constancia_trabajo_con_ciclicos]    Script Date: 11/22/2016 2:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [pa].[rpe_constancia_trabajo_con_ciclicos]
    @codcia int,
    @codexp	int = null,
    @coduni	int = null,
    @fecha  datetime = null,
    @destinatario varchar(255) = null,
    @codexp_firmante int = null
as

-- exec pa.rpe_constancia_trabajo_con_ciclicos 1, 2, null, '2012-07-05', 'BANCO', 1

--declare @codcia int, @coduni int, @codemp int, @fecha datetime, @destinatario varchar(255)
--select @codcia = 1, @codemp = 515, @destinatario = 'Banco General'
set nocount on

set @destinatario = coalesce(@destinatario, 'A Quien Concierne')

-- Inicializa la fecha con el dia de hoy si viene nula
set @fecha = isnull(@fecha, getdate())

declare @nombre_firmante varchar(108), @nombre_puesto_firmante varchar(80), @ubicacion varchar(50)

declare @codpai varchar(2), @codtdo_cedula int, @codtdo_seguro_social int, @codrsa_salario int, @codrsa_gasto_rep int, @codemp int, @cia_des varchar(150)

select @codpai = cia_codpai, @cia_des = cia_descripcion
from eor.cia_companias
where cia_codigo = @codcia

select @codtdo_cedula = COALESCE(gen.get_valor_parametro_int ('CodigoDoc_Cedula', @codpai, null, null, null), -1),
	   @codtdo_seguro_social = COALESCE(gen.get_valor_parametro_int ('CodigoDoc_SeguroSocial', @codpai, null, null, null), -1),
	   @codrsa_salario = COALESCE(gen.get_valor_parametro_int ('CodigoRubroSalario', null, null, @codcia, null), -1),
	   @codrsa_gasto_rep = COALESCE(gen.get_valor_parametro_int ('CodigoRubroGastoRep', null, null, @codcia, null), -1)

SELECT @nombre_firmante = exp_nombres_apellidos,
	   @nombre_puesto_firmante = PLZ_NOMBRE,
	   @ubicacion = cdt_descripcion
FROM exp.exp_expedientes
join exp.emp_empleos
on emp_codexp = exp_codigo
JOIN eor.plz_plazas
ON PLZ_CODIGO = EMP_CODPLZ
JOIN eor.cdt_centros_de_trabajo
ON cdt_codigo = plz_codcdt
WHERE exp_codigo = @codexp_firmante

-- Obtiene los descuentos cíclicos
create table #cartas (
    fecha varchar(255),
    destinatario varchar(255),
    codexp int,
	codemp int,
    nombre_empleado varchar(255),
    cedula varchar(20),
    seguro varchar(255),
    fecha_ingreso varchar(255),
    primer_apellido varchar(50),
    nombre_plaza varchar(255),
    nombre_unidad varchar(255),
    total_salario varchar(255),
    salario varchar(255),
    gastos_rep varchar(255),
    parrafo_gastos_rep varchar(1000),
    dcc1 varchar(255),
    dcc_valor1 varchar(255),
    dcc2 varchar(255),
    dcc_valor2 varchar(255),
    dcc3 varchar(255),
    dcc_valor3 varchar(255),
    dcc4 varchar(255),
    dcc_valor4 varchar(255),
    dcc5 varchar(255),
    dcc_valor5 varchar(255),
    dcc6 varchar(255),
    dcc_valor6 varchar(255),
    dcc7 varchar(255),
    dcc_valor7 varchar(255),
    dcc8 varchar(255),
    dcc_valor8 varchar(255),
    parrafo_dcc varchar(8000),
    parrafo_dcc2 varchar(8000),
    parrafo_dcc3 varchar(8000)
)

insert into #cartas
   (codexp, codemp, nombre_empleado, cedula, seguro, fecha_ingreso, 
    primer_apellido, nombre_plaza, nombre_unidad,
    total_salario, salario, gastos_rep)
select exp_codigo, emp_codigo, 
       exp_nombres_apellidos, 
       isnull(cedulas.ide_numero, '<No especificada>'), isnull(seguros_social.ide_numero, '<No especificada>'), 
       cast(day(emp_fecha_ingreso) as varchar) + ' de ' + 
            lower(gen.fn_get_NombreMes(month(emp_fecha_ingreso))) + ' de ' +
            cast(year(emp_fecha_ingreso) as varchar),
       exp_primer_ape,
       plz_nombre, 
       uni_descripcion,
       '',--'B/.' + convert(varchar(100), emp_salario + isnull(emp_bonificacion, 0), 1), 
       'B/.' + convert(varchar(100), salarios.ese_valor, 1),
       isnull('B/.' + convert(varchar(100), gastos_rep.ese_valor,1), '')
    from exp.exp_expedientes
	join exp.emp_empleos
	on emp_codexp = exp_codigo
  join eor.plz_plazas on emp_codplz = plz_codigo
  join eor.uni_unidades on plz_coduni = uni_codigo
  left join (select ide_codexp, ide_numero from exp.ide_documentos_identificacion where ide_codtdo = @codtdo_cedula) cedulas on cedulas.ide_codexp = exp_codigo
  left join (select ide_codexp, ide_numero from exp.ide_documentos_identificacion where ide_codtdo = @codtdo_seguro_social) seguros_social on seguros_social.ide_codexp = exp_codigo
  --left join exp.fn_get_datos_rubro_salarial (null, 'S', @fecha, @codpai) salarios on 
  left join exp.ese_estructura_sal_empleos salarios on salarios.ese_codemp = emp_codigo and salarios.ese_estado = 'V' and salarios.ese_codrsa = @codrsa_salario
  left join exp.ese_estructura_sal_empleos gastos_rep on gastos_rep.ese_codemp = emp_codigo and gastos_rep.ese_estado = 'V' and gastos_rep.ese_codrsa = @codrsa_salario
 where exp_codigo = isnull(@codexp, exp_codigo)
   and plz_coduni = isnull(@coduni, plz_coduni)
    
update #cartas
   set fecha = cast(day(@fecha) as varchar) + ' de ' + 
               lower(gen.fn_get_NombreMes(month(@fecha))) + ' de ' +
               cast(year(@fecha) as varchar),
       destinatario = @destinatario,
       parrafo_gastos_rep = case when gastos_rep != '' and gastos_rep != 'B/.0.00'
                                 then /*' dividido en ' + */salario + ' como salario y '/*'en '*/ + gastos_rep + ' como gastos de representación.'
                                 when (gastos_rep = '' or gastos_rep = 'B/.0.00')
                                 then /*' dividido en ' + */salario + ' como salario.'
                                 else '.'
                            end

declare @i int, @bco varchar(255), @dcc money, @prev_codemp int, @xsql varchar(8000)
set @prev_codemp = -1
set @i = 0

declare cDCC cursor read_only forward_only for
select dcc_codemp,
       bca_nombre,
        sum(CONVERT(numeric(12,2), coalesce(dcc_valor_cuota,0)) * 2) pre_valor
  from sal.dcc_descuentos_ciclicos
  join gen.bca_bancos_y_acreedores on bca_codigo = dcc_codbca
 where dcc_activo = 1
   and exists (select 1 from #cartas where codemp = dcc_codemp)
 group by dcc_codemp, bca_nombre
 order by dcc_codemp, bca_nombre

open cDCC
fetch next from cDCC into @codemp, @bco, @dcc

while @@fetch_status = 0
begin
    if @prev_codemp != @codemp
    begin
        set @prev_codemp = @codemp
        set @i = 1
    end


    else 
        set @i = @i + 1

    if @i between 1 and 8
    begin
        set @xSQL = 'update #cartas' +
                      ' set dcc' + cast(@i as varchar)+ ' = ''' + @bco + + ''', ' +
                          ' dcc_valor' + cast(@i as varchar)+ ' = ''' + 'B/.' + convert(varchar(100), @dcc, 1) + '''' +
                    ' where codemp =' + cast(@prev_codemp as varchar)
        exec (@xSQL)
    end

    fetch next from cDCC into @codemp, @bco, @dcc
end

close cDCC
deallocate cDCC

--*
--* Convierte el detalle de ciclicos en un párrafo
--*
declare @cr char(2), @t char(1)
set @t = char(9)
set @cr = char(13) + char(10)

update #cartas
   set parrafo_dcc = case when dcc1 is null and dcc2 is null and dcc3 is null and dcc4 is null and dcc5 is null
                          then 'A este importe mensual se le retienen las deducciones exigidas por la ley en nuestro país. Por el momento, no registra otros descuentos adicionales en su salario mensual.'--'Solamente tiene las Deducciones de Ley.'
                          else 'Adicional a las deducciones de Ley, tiene los siguientes descuentos mensuales:' + @cr + @cr
                     end,
   parrafo_dcc2 = case when dcc1 is null and dcc2 is null and dcc3 is null and dcc4 is null and dcc5 is null and dcc6 is null and dcc7 is null and dcc8 is null
                          then ''--'Solamente tiene las Deducciones de Ley.'
                          else --'Adicional a las deducciones de Ley, tiene los siguientes descuentos mensuales:' + @cr + @cr +
                               isnull(@t + dcc1 + @t + dcc_valor1 + @cr, '') +
                               isnull(@t + dcc2 + @t + dcc_valor2 + @cr, '') +
               isnull(@t + dcc3 + @t + dcc_valor3 + @cr, '') +
                               isnull(@t + dcc4 + @t + dcc_valor4 + @cr, '') +
                               isnull(@t + dcc5 + @t + dcc_valor5 + @cr, '')
                     end,

   parrafo_dcc3 = case when dcc6 is null and dcc7 is null and dcc8 is null
                          then ''--'Solamente tiene las Deducciones de Ley.'
                          else --'Adicional a las deducciones de Ley, tiene los siguientes descuentos mensuales:' + @cr + @cr +
                               isnull(@t + dcc6 + @t + dcc_valor6 + @cr, '') +
                               isnull(@t + dcc7 + @t + dcc_valor7 + @cr, '') +
                               isnull(@t + dcc8 + @t + dcc_valor8 + @cr, '') + @cr
                     end

-- Regresa la tabla temporal
select @cia_des cia_des, @nombre_firmante FIRMANTE, @nombre_puesto_firmante PUESTO, @ubicacion CENTRO, * from #cartas

drop table #cartas
return

GO
