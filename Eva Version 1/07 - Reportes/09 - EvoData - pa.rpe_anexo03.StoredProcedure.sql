IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.rpe_anexo03')
                    AND type IN ( N'P', N'PC' ) )

DROP PROCEDURE [pa].[rpe_anexo03]
GO
/****** Object:  StoredProcedure [pa].[rpe_anexo03]    Script Date: 11/22/2016 2:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [pa].[rpe_anexo03]
   @codcia  int,
   @anio    int,
   @mes     int = null,
   @coduni	int = null,
   @verAcumulado varchar(1) = null
as
begin

set nocount on
set dateformat dmy

-- exec rpe_anexo03 1,2012,2,NULL, 'N'

set @verAcumulado = coalesce(@verAcumulado, 'S')

SELECT *
FROM pa.fn_anexo03(@codcia, @anio, @mes, @coduni, @verAcumulado, 'R')

end

GO
