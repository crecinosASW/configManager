/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:17 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '979e2f29-5185-4ce8-af52-f90ae5a5bbaa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('979e2f29-5185-4ce8-af52-f90ae5a5bbaa','GastoRepresentacion_v','Valor de Gastos de Representacion','Function GastoRepresentacion_v()

Salario = 0
Vacacion = 0
S = 0
dv = 0
hrsVacacion = 0

MontosPagoVacacion.Filter = "mpv_tipo_ingreso=''G'' and mpv_codemp=" & CStr( Emp_InfoSalario.Fields("emp_codigo").Value )

'' Recupera los valores de pago de vacaciones
if not MontosPagoVacacion.EOF then
   Salario = CDbl(MontosPagoVacacion.Fields("mpv_salario").Value)
   ''Vacacion = CDbl(MontosPagoVacacion.Fields("mpv_promedio").Value)

   '' Busca el monto mayor de entre los 2 anteriormente calculados
   
   ''if Vacacion > Salario then
   ''   S = Vacacion
   ''else
   ''   S = Salario
   ''end if
   
   dv = CInt(MontosPagoVacacion.Fields("mpv_dias").Value)
   
   ''S = (S/30.00) * dv
   S = CDbl(MontosPagoVacacion.Fields("mpv_pagado").Value)
   
   ''MontosPagoVacacion.Fields("mpv_pagado").Value = S
   ''MontosPagoVacacion.Fields("mpv_promedio").Value = Vacacion / 30.00 * dv
   ''MontosPagoVacacion.Fields("mpv_salario").Value = Salario / 30.00 * dv
end if

''if Emp_InfoSalario.Fields("emp_codigo").Value = 3 then
''   msgbox "S: " & cstr(S) & vbCrLf & _
''          "Salario: " & cstr(Salario) & vbCrLf & _
''          "Vacacion: " & cstr(Vacacion) & vbCrLf & _
''          "salarioVacacion: " & cstr(salarioVacacion) & vbCrLf & _
''          "hrsVacacion: " & cstr(hrsVacacion) & vbCrLf & _
''          "salario x hora: " & cstr(Emp_InfoSalario.Fields("emp_salario_hora").Value)
''end if

'' Graba en los historiales de ingresos los resultados
if not isnull(Factores("GastoRepresentacion_v").CodTipoIngreso) and S > 0 then
   agrega_ingresos_historial Agrupadores, _
                             IngresosEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("GastoRepresentacion_v").CodTipoIngreso, _
                             S, "PAB", dv, "Dias"
end if

GastoRepresentacion_v = S
End Function','double','pa',0);

commit transaction;
