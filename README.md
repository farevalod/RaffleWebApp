# Aplicación Web para Gestión de Rifas #

#### Ricardo Del Río G. ####

Está aplicación está diseñada para ser utilizada por 3 tipos de usuarios:

* Vendedores:
Son los encargados de vender los boletos de la rifa. Poseen talonarios y solo pueden seleccionar boletos para la venta e ingresar los datos del comprador.

* Admins (o Aministradores de Institución):
Pueden crear a otros administradores, grupos de vendedores y vendedores. Pueden editar algunos datos. Pueden eliminar grupos de vendedores, vendedores y talonarios solo si estos no poseen boletos vendidos.
Se dividen en 2 categorías: Primarios y Secundarios. La única diferencia es que los secundarios no pueden eliminar a primarios. Los primarios no pueden eliminarse entre sí.
Estos administradores pueden ingresar los pagos que los vendedores han hecho a la institución.

* Super Admins (o Administradores de Aplicación):
Crean instituciones y a los administradores de institución primarios. Pueden editar y modificar los datos de cualquiera de los elementos que componen la aplicación. 
Al igual que los admins de institución poseen 2 categorías: Primarios y Secundarios. Los secundarios no pueden eliminar nimodificar a los primarios. Los primarios se pueden eliminar entre ellos, siempre cuando quede al menos uno. Los primarios pueden crear otras admins primarios o secundarios. Los secundarios solo pueden crear secuandarios.

Ejemplo:

* En un contexto escolar el administrador de institución primario podrá ser el Director de la escuela.

* Los administradores secundarios pueden corresponer a los profesores de los cursos y a l@s secretari@s u otros directivos.

* Los vendedores serían los estudiantes de los cursos y, dependiendo del caso, también los profesores.

* EL admnistrador de aplicación será quien establesca contacto con el director del colegio y guíe y gestione la implementación y desarrollo de la rifa digital.


