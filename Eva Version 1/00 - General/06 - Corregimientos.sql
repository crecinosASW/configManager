DELETE FROM gen.mun_municipios
WHERE mun_coddep IN (SELECT dep_codigo FROM gen.dep_departamentos WHERE dep_codpai='pa') 
SET NOCOUNT ON
 
SET IDENTITY_INSERT [gen].[mun_municipios] ON
GO
 
 
PRINT 'Inserting values into mun_municipios'

INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1775, 71, 'PANAMA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1776, 71, 'BALBOA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1777, 71, 'CHEPO', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1778, 71, 'LA CHORRERA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1779, 71, 'ARRAIJ�N', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1780, 79, 'PINOGANA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1781, 79, 'CHEPIGANA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1782, 78, 'COLON', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1783, 78, 'PORTOBELO', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1784, 78, 'CHAGRES', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1785, 77, 'ANTON', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1786, 77, 'LA PINTADA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1787, 77, 'PENONOME', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1788, 77, 'AGUADULCE', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1789, 75, 'CHITRE', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1790, 76, 'LAS TABLAS', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1791, 76, 'LOS SANTOS', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1792, 72, 'SANTA FE', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1793, 72, 'SANTIAGO', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1794, 72, 'ATALAYA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1795, 73, 'BOCAS DEL TORO', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1796, 73, 'CHANGUINOLA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1797, 73, 'CHIRIQUI GRANDE', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1798, 74, 'ALANJE', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1799, 74, 'BARU', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1800, 74, 'DAVID', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1801, 74, 'BOQUER�N', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1802, 74, 'BOQUETE', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1803, 74, 'BUGABA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1804, 74, 'DOLEGA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1805, 74, 'GUALACA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1806, 77, 'NAT�', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1807, 77, 'OL�', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1808, 78, 'DONOSO', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1809, 78, 'SANTA ISABEL', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1810, 74, 'REMEDIOS', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1811, 74, 'RENACIMIENTO', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1812, 74, 'SAN F�LIX', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1813, 74, 'SAN LORENZO', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1814, 74, 'TOL�', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1815, 75, 'LAS MINAS', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1816, 75, 'LOS POZOS', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1817, 75, 'OC�', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1818, 75, 'PARITA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1819, 75, 'PES�', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1820, 75, 'SANTA MAR�A', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1821, 76, 'MACARACAS', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1822, 76, 'PEDAS�', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1823, 76, 'POCR�', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1824, 76, 'TONOS�', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1825, 71, 'CAPIRA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1826, 71, 'CHAME', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1827, 71, 'CHIM�N', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1828, 71, 'SAN CARLOS', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1829, 71, 'SAN MIGUELITO', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1830, 71, 'TABOGA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1831, 72, 'CALOBRE', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1832, 72, 'CA�AZAS', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1833, 72, 'LA MESA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1834, 72, 'LAS PALMAS', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1835, 72, 'MONTIJO', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1836, 72, 'R�OS DE JESUS', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1837, 72, 'SAN FRANCISCO', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1838, 72, 'SON�', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1839, 72, 'KUNA YALA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_codigo, mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (1840, 80, 'SAN BLAS', NULL, NULL, NULL, NULL, NULL, NULL)


PRINT 'Done'
 
 
SET IDENTITY_INSERT [gen].[mun_municipios] OFF
GO
SET NOCOUNT OFF
