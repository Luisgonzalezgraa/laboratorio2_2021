
/*TDA socialNetwork: Lista con el nombre de la red social y la fecha de creacion que es tipo TDA date.
 * [Name,[RegistroUsuarios],[Publicaciones],[Seguidos],[Compartidos],[date]].
 * Name = string. date = lista de enteros.
*/
socialNetwork(Name,Date,SOut):-
    SOut = [Name,Date,[],[],[],[],[]].


/*TDA socialNetwork: Lista de enteros con el dia el mes y el a駉.
 * [Name,[date]].
 * Name = string.
 * date = lista de enteros.
*/
date(Day,Month,Year,OutDate):-
     OutDate = [Day,"/",Month,"/",Year].

registroUsuario(Fecha,NameU,Password, [Fecha,NameU,Password]).


%selectores TDA socialNetwork.
getName([Name|_],Name).
getDate([_|[Date|_]],Date).
getRegister([_|[_|[Registro|_]]],Registro).
getUsuarioA([_|[_|[_|[UsuarioA|_]]]],UsuarioA).
getPost([_|[_|[_|[_|[Post|_]]]]],Post).
getFollow([_|[_|[_|[_|[_|[Follow|_]]]]]],Follow).
getShare([_|[_|[_|[_|[_|[_|[Share|_]]]]]]],Share).


%selectores TDA registroUsuario.
getNameU([NameU|_],NameU).
getPassword([_|[Password|_]],Password).

%-------------------------------------
%############BASE DE CONOCIMIENTOS: RED SOCIAL##################
%socialNetwork("Facebook",[5,10,2020],SocialNetwork1):-
    %SocialNetwork1 = [[["luis","pass"],["karla","pass2"],["javiera","pass3"],["marco","pass4"]],[],[[[9,12,2019],"luis","primer post para todos",[]],[[9,12,2019],"luis","post para karla y javiera",[karla,javiera]],[[9,12,2019],"karla","primer post para luis",[luis]]],[["luis"," sigue a","karla"]],[]].
%-------------------------------------

/*----------------------------------------------------------------
Predicado socialNetworkRegister: Registra a un nuevo usuario en la
plataforma.
Dom: socialNetworw X string X string
Rec: socialNetworw
Recursion: Natural
Ejemplo de uso:
 */
socialNetworkRegister(ListaI,Fecha,Name,Password,Lista2):-
    getRegister(ListaI,Registro),
    getName(ListaI,NameSocial),
    getUsuarioA(ListaI,UsuarioA),
    getPost(ListaI,Posteo),
    getFollow(ListaI,Follow),
    getShare(ListaI,Share),
    getDate(ListaI,Date),
    Registro == [],
     !,
    Lista2 = [NameSocial,Date,[[Fecha,Name,Password]],UsuarioA,Posteo,Follow,Share].
socialNetworkRegister(SocialNet,FechaInicio,Name,Password,SocialNet2):-
    getRegister(SocialNet,Registro),
    not(elementoEnLista(Registro,Name)),
    getName(SocialNet,NombreRed),
    getDate(SocialNet,Fecha),
    getUsuarioA(SocialNet,UsuarioA),
    getPost(SocialNet,Posteo),
    getFollow(SocialNet,Follow),
    getShare(SocialNet,Share),
    registroUsuario(FechaInicio,Name,Password,ListaUsuario),
    append(Registro,[ListaUsuario],Registro2),!,
    SocialNet2 = [NombreRed,Fecha,Registro2,UsuarioA,Posteo,Follow,Share].


/*----------------------------------------------------------------
Predicado socialNetworkRegister: Registra a un nuevo usuario en la
plataforma.
Dom: socialNetworw X string X string
Rec: socialNetworw
Recursion: Natural
Ejemplo de uso:
 */


socialNetworkLogin(SocialNet, _, _,_):-
     getRegister(SocialNet,Registro),
     Registro == [],
     !,false.
socialNetworkLogin(SocialNet,Name,Password,SocialNet2):-
    getRegister(SocialNet,Registro),
    existeUsuario(Registro,Name,Password),
    getUsuarioA(SocialNet,UsuarioA),
    getName(SocialNet,NombreRed),
    getDate(SocialNet,Fecha),
    getPost(SocialNet,Posteo),
    getFollow(SocialNet,Follow),
    getShare(SocialNet,Share),
    append(UsuarioA,["Usuario Activo",Name],UsuarioActivo),!,
    SocialNet2 =[NombreRed,Fecha,Registro,UsuarioActivo,Posteo,Follow,Share].



/*----------------------------------------------------------------
Predicado socialNetworkRegister: Registra a un nuevo usuario en la
plataforma.
Dom: socialNetworw X string X string
Rec: socialNetworw
Recursion: Natural
Ejemplo de uso:
 */

socialNetworkPost(SocialNet,_,_,_,_):-
    getUsuarioA(SocialNet,UsuarioA),
    UsuarioA == [],
    !,
    false.

socialNetworkPost(SocialNet,Fecha,Contenido,ListaUsuarios,SocialNet2):-
    getPost(SocialNet,Post),
    getUsuarioA(SocialNet,UsuarioA),
    Post == [],
    !,
    getRegister(SocialNet,Registro),
    getUsers(Registro,[],Registro2),
    existeContacto(Registro2,ListaUsuarios),
    obtenerCola(UsuarioA,Cola),
    obtenerElemento(Cola,NombreUsuario),
    getName(SocialNet,NombreRed),
    getDate(SocialNet,FechaS),
    getFollow(SocialNet,Follow),
    getShare(SocialNet,Share),
    SocialNet2 = [NombreRed,FechaS, Registro,[],[[1,Fecha,NombreUsuario,Contenido,ListaUsuarios]],Follow,Share],!.

socialNetworkPost(SocialNet,Fecha,Contenido,ListaUsuarios,SocialNet2):-
    getRegister(SocialNet,Registro),
    getUsers(Registro,[],Registro2),
    existeContacto(Registro2,ListaUsuarios),
    getUsuarioA(SocialNet,UsuarioA),
    getPost(SocialNet,Post),
    obtenerCola(UsuarioA,Cola),
    obtenerElemento(Cola,NombreUsuario),
    getRegister(SocialNet,Registro),
    getName(SocialNet,NombreRed),
    getDate(SocialNet,FechaS),
    getFollow(SocialNet,Follow),
    getShare(SocialNet,Share),
    my_last_element(Post,ListaNu),
    obtenerCabeza(ListaNu,Numero),
    sumarDosNumeros(Numero,1,NumeroFinal),
    append(Post,[[NumeroFinal,Fecha,NombreUsuario,Contenido,ListaUsuarios]],PostFinal),
    SocialNet2 = [NombreRed,FechaS, Registro,[],PostFinal,Follow,Share],!.

/*----------------------------------------------------------------
Predicado socialNetworkRegister: Registra a un nuevo usuario en la
plataforma.
Dom: socialNetworw X string X string
Rec: socialNetworw
Recursion: Natural
Ejemplo de uso:
 */

socialNetworkFollow(SocialNet,UserName,_):-
    getUsuarioA(SocialNet,UsuarioA),
    obtenerCola(UsuarioA,Cola),
    obtenerElemento(Cola,NombreUsuario),
    NombreUsuario == UserName,
    !,
    false;
    UserName == "",
    !,
    false;
    getUsuarioA(SocialNet,UsuarioA),
    UsuarioA == [],
    !,
    false.
socialNetworkFollow(SocialNet,Username,SocialNet2):-
    getFollow(SocialNet,Follow),
    Follow == [],
    !,
    getName(SocialNet,NombreRed),
    getDate(SocialNet,FechaS),
    getRegister(SocialNet,Registro),
    elementoEnLista(Registro,Username),
    getUsuarioA(SocialNet,UsuarioA),
    obtenerCola(UsuarioA,Cola),
    obtenerElemento(Cola,NombreUsuario),
    getPost(SocialNet,Post),
    getShare(SocialNet,Share),
    SocialNet2 = [NombreRed,FechaS,Registro,[],Post,[[NombreUsuario, "\n      sigue a: ", Username]],Share],!.
 socialNetworkFollow(SocialNet,Username,SocialNet2):-
   getUsuarioA(SocialNet,UsuarioA),
   obtenerCola(UsuarioA,Cola),
   obtenerElemento(Cola,NombreUsuario),
   getRegister(SocialNet,Register),
   elementoEnLista(Register,Username),
   getName(SocialNet,NombreRed),
   getDate(SocialNet,FechaS),
   getPost(SocialNet,Post),
   getFollow(SocialNet,Follow),
   getShare(SocialNet,Share),
   append(Follow,[[NombreUsuario, "\n      sigue a: ",Username]],Follow2),
   SocialNet2 = [NombreRed,FechaS,Register,[],Post,Follow2,Share],!.

/*----------------------------------------------------------------
Predicado socialNetworkRegister: Registra a un nuevo usuario en la
plataforma.
Dom: socialNetworw X string X string
Rec: socialNetworw
Recursion: Natural
Ejemplo de uso:
 */

socialNetworkShare(SocialNet,Fecha,PostId,Destinatarios,SocialNet2):-
    getShare(SocialNet,Share),
    getPost(SocialNet,Post),
    idEnLista(Post,PostId,ListaContenidoPost),
    Share == [],
    !,
    getName(SocialNet,NombreRed),
    obtenerCabeza(ListaContenidoPost,Cabeza),
    obtenerMedio(ListaContenidoPost,NombrePosteador,Publi),
    getDate(SocialNet,FechaS),
    getRegister(SocialNet,Registro),
    getUsers(Registro,[],Registro2),
    existeContacto(Registro2,Destinatarios),
    getFollow(SocialNet,Follow),
    getUsuarioA(SocialNet,UsuarioA),
    obtenerCola(UsuarioA,Cola),
    obtenerElemento(Cola,NombreUsuario),
    SocialNet2 = [NombreRed,FechaS,Registro,[],Post,Follow,[[Cabeza,NombrePosteador,Publi,"Compartido: \n",Fecha,NombreUsuario,Destinatarios]] ],!.
socialNetworkShare(SocialNet,Fecha,PostId,Destinatarios,SocialNet2):-
    getShare(SocialNet,Share),
    getPost(SocialNet,Post),
    idEnLista(Post,PostId,ListaContenidoPost),
    getName(SocialNet,NombreRed),
    getDate(SocialNet,FechaS),
    getRegister(SocialNet,Registro),
    getUsers(Registro,[],Registro2),
    existeContacto(Registro2,Destinatarios),
    getFollow(SocialNet,Follow),
    getShare(SocialNet,Share),
    getUsuarioA(SocialNet,UsuarioA),
    obtenerCola(UsuarioA,Cola),
    obtenerElemento(Cola,NombreUsuario),
    obtenerCabeza(ListaContenidoPost,Cabeza),
    obtenerMedio(ListaContenidoPost,NombrePosteador,Publi),
    ShareF = [Cabeza,NombrePosteador,Publi,"Compartido: \n",Fecha,NombreUsuario,Destinatarios],
    append(Share,[ShareF],ShareFinal),
    SocialNet2 = [NombreRed,FechaS,Registro,[],Post,Follow,ShareFinal],!.



/*----------------------------------------------------------------
Predicado socialNetworkRegister: Registra a un nuevo usuario en la
plataforma.
Dom: socialNetworw X string X string Rec: socialNetworw
Recursion: Natural
Ejemplo de uso:
 */



socialNetworkToString(SocialNet,SocialNet2):-
    getUsuarioA(SocialNet,UsuarioA),
    UsuarioA == [],!,
    getName(SocialNet,NombreRed),
    getDate(SocialNet,Date),
    getRegister(SocialNet,Register),
    getUsers(Register,[],Register2),
    getFollow(SocialNet,Follow),
    getFollow(SocialNet,Follow2),
    getPost(SocialNet,Post),
    getShare(SocialNet,Share),
    lista2String(Date,DateString),
    string_concat("\n#### Nombre de la red social: ",NombreRed,String1),string_concat(String1," ####\n",String2),
    string_concat(String2,"####Creaci髇 de la red social: ",String3),string_concat(String3,DateString,String4),
    string_concat(String4,"####\n",String5),
    string_concat(String5,"*** Usuarios Registrados ***\n",String6),
    register2String(Follow,Follow2,Register2,RegisterString),
    string_concat(String6,RegisterString,String7),
    string_concat(String7,"------------------------------------------------\n",String8),
    string_concat(String8,"**************PUBLICACIONES*********************\n",String9),
    post2String(Post,Share,PostString),
    string_concat(String9,PostString,String10),
    string_concat(String10,"*************FIN PUBLICACIONES*****************\n",SocialNet2),!.

socialNetworkToString(SocialNet,SocialNet2):-
    getUsuarioA(SocialNet,UsuarioA),
    obtenerCola(UsuarioA,NombreUsuario),
    obtenerElemento(NombreUsuario,Usuario),
    getName(SocialNet,NombreRed),
    getDate(SocialNet,Date),
    getFollow(SocialNet,Follow),
    getPost(SocialNet,Post),
    getShare(SocialNet,Share),
    lista2String(Date,DateString),
    string_concat("\n#### Nombre de la red social: ",NombreRed,String1),string_concat(String1," ####\n",String2),
    string_concat(String2,"####Creaci髇 de la red social: ",String3),string_concat(String3,DateString,String4),
    string_concat(String4,"####\n",String5),
    string_concat(String5,"*** Usuarios Con sesi髇 iniciada ***\n",String6),
    string_concat(String6,Usuario,String7),
    follow2String2(Follow,Usuario,RegisterString),
    string_concat(String7,RegisterString,String8),
    string_concat(String8,"------------------------------------------------\n",String9),
    string_concat(String9,"**************PUBLICACIONES*********************\n",String10),
    post2String2(Post,Usuario,PostString),
    string_concat(String10,PostString,String11),
    string_concat(String11,"------------------------------------------------\n",String12),
    string_concat(String12,"**************PUBLICACIONES COMPARTIDAS*********************\n",String13),
    share2String(Share,Usuario,ShareString),
    string_concat(String13,ShareString,String14),
    string_concat(String14,"**************FIN PUBLICACIONES COMPARTIDAS*********************\n",String15),
    string_concat(String15,"------------------------------------------------\n",SocialNet2).







% ------------------------------------------------------------------------

 /* Funci贸n elementoEnLista: Verifica si un elemento esta en la lista.
 * Dominio: Lista x elemento
 * Recorrido: Booleano
 */
elementoEnLista([],_):- false, !.
elementoEnLista([[_,X,_]|Y],Elemento):- X = Elemento; elementoEnLista(Y,Elemento).

 /* Funci贸n elementoEnLista: Verifica si un elemento esta en la lista.
 * Dominio: Lista x elemento
 * Recorrido: Booleano
 */
shareEnLista([],_,_,_):- false, !.
shareEnLista([[X,_,_,M,N,B,V]|W],Elemento,String,Lista):- X = Elemento,String = M,Lista = [N,B,V]; shareEnLista(W,Elemento,String,Lista).


 /* Funci贸n elementoEnLista: Verifica si un elemento esta en la lista.
 * Dominio: Lista x elemento
 * Recorrido: Booleano
 */
idEnLista([],_,_):- false, !.
idEnLista([[X,_,Z,O,_]|W],Elemento,Lista):- X = Elemento,Lista = [X,Z,O]; idEnLista(W,Elemento,Lista).

 /* Funci贸n elementoEnLista: Verifica si un elemento esta en la lista.
 * Dominio: Lista x elemento
 * Recorrido: Booleano
 */
existeUsuario([],_,_):- false, !.
existeUsuario([[_,X,Z]|Y],Elemento,Elemento2):- X = Elemento, Z = Elemento2; existeUsuario(Y,Elemento,Elemento2).

 /* Funci贸n elementoEnLista: Verifica si un elemento esta en la lista.
 * Dominio: Lista x elemento
 * Recorrido: Booleano
 */
obtenerCola([_|X],Elemento):- X = Elemento,!.

 /* Funci贸n elementoEnLista: Verifica si un elemento esta en la lista.
 * Dominio: Lista x elemento
 * Recorrido: Booleano
 */
obtenerElemento([X],Elemento):- X = Elemento,!.

 /* Funci贸n elementoEnLista: Verifica si un elemento esta en la lista.
 * Dominio: Lista x elemento
 * Recorrido: Booleano
 */
obtenerCabeza([X|_],Elemento):- X =Elemento,!.

 /* Funci贸n elementoEnLista: Verifica si un elemento esta en la lista.
 * Dominio: Lista x elemento
 * Recorrido: Booleano
 */
obtenerMedio([_,X,C],Elemento1,Elemento2):- X = Elemento1,C = Elemento2,!.

 /* Funci贸n elementoEnLista: Verifica si un elemento esta en la lista.
 * Dominio: Lista x elemento
 * Recorrido: Booleano
 */
lista2String([],"").
lista2String([CabezaArch|ColaArch],Lista):-
    string_concat("",CabezaArch,String),lista2String(ColaArch,String2),string_concat(String,String2,Lista).






 /* Funci贸n elementoEnLista: Verifica si un elemento esta en la lista.
 * Dominio: Lista x elemento
 * Recorrido: Booleano
 */
post2String(Post,_,Lista):-
    Post == [],
    string_concat("\n","\n",Lista),!.
post2String([[CabezaArch,Dia,Nombre,Publicacion,Destinatarios]|ColaArch],Share,Lista):-
    shareEnLista(Share,CabezaArch,Compartido,ListaShare),
    obtenerCabeza(ListaShare,X),
    obtenerMedio(ListaShare,Y,Z),
    lista2String(Z,CompartidosHacia),
    lista2String(Dia,Date),
    lista2String(X,DateShare),
    verificarVacio(Destinatarios,Destinatarios,StringDest),
    string_concat("ID: ",CabezaArch,String),string_concat(String,"\nEl dia ",String2),string_concat(String2,Date,String3),
    string_concat(String3," ",String4),string_concat(String4,Nombre,String5),string_concat(String5," publico:\n",String6),
    string_concat(String6,"    ",String7),string_concat(String7,Publicacion,String8),
    string_concat(String8,"\n",String9),string_concat(String9,"Destinatarios: ",String10),
    string_concat(String10,StringDest,String11),string_concat(String11,"\n",String12),
    string_concat(String12,Compartido,String13),string_concat(String13,"    ",String14),
    string_concat(String14,"El d韆 ",String15),string_concat(String15,DateShare,String16),
    string_concat(String16," por ",String17),string_concat(String17,Y,String18),
    string_concat(String18," hacia: ",String19),string_concat(String19,CompartidosHacia,String20),string_concat(String20,"\n",String21),
    post2String(ColaArch,Share,String22),string_concat(String21,String22,Lista),!;

    verificarVacio(Destinatarios,Destinatarios,StringDest2),
    lista2String(Dia,Date2),
    string_concat("ID: ",CabezaArch,Strings),string_concat(Strings,"\nEl dia ",Strings2),string_concat(Strings2,Date2,Strings3),
    string_concat(Strings3," ",Strings4),string_concat(Strings4,Nombre,Strings5),string_concat(Strings5," publico:\n",Strings6),
    string_concat(Strings6,"    ",Strings7),string_concat(Strings7,Publicacion,Strings8),
    string_concat(Strings8,"\n",Strings9),string_concat(Strings9,"Destinatarios: ",Strings10),
    string_concat(Strings10,StringDest2,Strings11),string_concat(Strings11,"\n",Strings12),
    post2String(ColaArch,Share,Strings13),string_concat(Strings12,Strings13,Lista),!.

 /* Funci贸n elementoEnLista: Verifica si un elemento esta en la lista.
 * Dominio: Lista x elemento
 * Recorrido: Booleano
 */
post2String2(Post,_,Lista):-
    Post == [],
    string_concat("\n","\n",Lista),!.
post2String2([[_,_,Nombre,_,_]|Cola],UsuarioActivo,Lista):-
    Nombre \= UsuarioActivo,
    post2String2(Cola,UsuarioActivo,Lista).
post2String2([[CabezaArch,Dia,Nombre,Publicacion,Destinatarios]|Cola],UsuarioActivo,Lista):-
    Nombre == UsuarioActivo,
    lista2String(Dia,Date),
    verificarVacio(Destinatarios,Destinatarios,StringDest),
    string_concat("ID: ",CabezaArch,String),string_concat(String,"\nEl dia ",String2),string_concat(String2,Date,String3),
    string_concat(String3," ",String4),string_concat(String4,Nombre,String5),string_concat(String5," publico:\n",String6),
    string_concat(String6,"    ",String7),string_concat(String7,Publicacion,String8),
    string_concat(String8,"\n",String9),string_concat(String9,"Destinatarios: ",String10),
    string_concat(String10,StringDest,String11),string_concat(String11,"\n",String12),post2String2(Cola,UsuarioActivo,String13),string_concat(String12,String13,Lista),!.

 /* Funci贸n elementoEnLista: Verifica si un elemento esta en la lista.
 * Dominio: Lista x elemento
 * Recorrido: Booleano
 */

register2String(_,_,[],"").
register2String([],Follow2,[_|Colaa],Lista):- register2String(Follow2,Follow2,Colaa,Lista).
register2String([[NombreSeguidor,SigueA,_]|Cola],Follow2,[Cabeza|Colaa],Lista):-
    NombreSeguidor \= Cabeza,
    string_concat(Cabeza,SigueA,String),string_concat(String,"",String2),string_concat(String2,"\n\n",String3),register2String(Cola,Follow2,Colaa,String4),string_concat(String3,String4,Lista).
register2String([[NombreSeguidor,SigueA,NombreSeguid]|ColaA],Follow2,Register,Lista):-
    obtenerCabeza(Register,Cabeza),
    NombreSeguidor == Cabeza,
    string_concat(NombreSeguidor,SigueA,String),string_concat(String,NombreSeguid,String2),string_concat(String2,"\n\n",String3),register2String(ColaA,Follow2,Register,String4),string_concat(String3,String4,Lista).


 /* Funci贸n elementoEnLista: Verifica si un elemento esta en la lista.
 * Dominio: Lista x elemento
 * Recorrido: Booleano
 */
follow2String2(Follow,_,Lista):-
    Follow == [],
    string_concat("\n","\n",Lista),!.
follow2String2([[Nombre,_,_]|Cola],NombreUsuario,Lista):-
    Nombre \= NombreUsuario,
    follow2String2(Cola,NombreUsuario,Lista).
follow2String2([[Nombre,SigueA,NombreSeguido]|Cola],NombreUsuario,Lista):-
    Nombre == NombreUsuario,
    string_concat("",SigueA,String),string_concat(String,NombreSeguido,String2),string_concat(String2,"\n\n",String3),follow2String2(Cola,NombreUsuario,String4),string_concat(String3,String4,Lista),!.


 /* Funci贸n elementoEnLista: Verifica si un elemento esta en la lista.
 * Dominio: Lista x elemento
 * Recorrido: Booleano
 */
share2String(Post,_,Lista):-
    Post == [],
    string_concat("\n","\n",Lista),!.
share2String([[_,_,_,_,_,Nombre,_]|Cola],UsuarioActivo,Lista):-
    Nombre \= UsuarioActivo,
    share2String(Cola,UsuarioActivo,Lista).
share2String([[CabezaArch,NombrePublicador,Publicacion,_,Dia,Nombre,Destinatarios]|Cola],UsuarioActivo,Lista):-
    Nombre == UsuarioActivo,
    lista2String(Dia,Date),
    verificarVacio(Destinatarios,Destinatarios,StringDest),
    string_concat("El dia ",CabezaArch,String),string_concat(String,Date,String2),string_concat(String2," Comparti� con ",String3),
    string_concat(String3,StringDest,String4),string_concat(String4," la publicaci髇 con id ",String5),string_concat(String5,CabezaArch,String6),
    string_concat(String6," de ",String7),string_concat(String7,NombrePublicador,String8),
    string_concat(String8,": ",String9),string_concat(String9,Publicacion,String10),
    string_concat(String10,"\n",String11),string_concat(String11,"\n",String12),share2String(Cola,UsuarioActivo,String13),string_concat(String12,String13,Lista),!.


 /* Funci贸n elementoEnLista: Verifica si un elemento esta en la lista.
 * Dominio: Lista x elemento
 * Recorrido: Booleano
 */
verificarVacio(ListaI,Igual,ListaF):-
    Igual == [],
    ListaI == [],
    !,
    string_concat(" Todos"," ",ListaF),!.
verificarVacio(ListaI,_,ListaF):-
    ListaI == [],
    string_concat("","",ListaF),!.
verificarVacio([Cabeza|Cola],Igual,ListaF):-
    string_concat(Cabeza," ",String),verificarVacio(Cola,Igual,String2),string_concat(String,String2,ListaF),!.


 /* Funci贸n elementoEnLista: Verifica si un elemento esta en la lista.
 * Dominio: Lista x elemento
 * Recorrido: Booleano
 */
existeContacto(_,[]):- !.
existeContacto(Usuarios,[C|T]):-
    member(C,Usuarios),
    existeContacto(Usuarios,T),!.

 /* Funci贸n elementoEnLista: Verifica si un elemento esta en la lista.
 * Dominio: Lista x elemento
 * Recorrido: Booleano
 */
getUsers([],Lista,Lista).
getUsers([[_,User,_]|Us],Lista,[User|Resultado]):-
	getUsers(Us,Lista,Resultado).

 /* Funci贸n elementoEnLista: Verifica si un elemento esta en la lista.
 * Dominio: Lista x elemento
 * Recorrido: Booleano
 */
sumarDosNumeros(X,Y,Z):- Z is X + Y.

 /* Funci贸n elementoEnLista: Verifica si un elemento esta en la lista.
 * Dominio: Lista x elemento
 * Recorrido: Booleano
 */
my_last_element([Y], Y).

my_last_element([_|Xs], Y):-
          my_last_element(Xs, Y).
/*
 * ##################### EJEMPLOS DE USO ##########################
 *
 * ------------Ejemplo 1--------------
 * date(05,10,2021,D1),socialNetwork("Facebook",D1,S1),socialNetworkRegister(S1,"25-05-202","luis","jas",S2),
socialNetworkRegister(S2,"22-03-2020","Carlos","sds",S3),socialNetworkRegister(S3,"22-03-2020","Javiera","hola",S4),
socialNetworkLogin(S4,"luis","jas",S5),
socialNetworkPost(S5,D1,"PRIMER POST",["Carlos","Javiera"],S6),socialNetworkLogin(S6,"Carlos","sds",S7),
socialNetworkPost(S7,D1,"SegundoPost",[],S8),socialNetworkLogin(S8,"luis","jas",S9),
socialNetworkShare(S9,D1,2,["Carlos"],S10),socialNetworkLogin(S10,"luis","jas",S11),
socialNetworkFollow(S11,"Carlos",S12),socialNetworkLogin(S12,"luis","jas",S13),socialNetworkFollow(S13,"Javiera",S14),
socialNetworkLogin(S14,"luis","jas",S15),
socialNetworkPost(S15,D1,"TERCER POST",[],S16),socialNetworkLogin(S16,"luis","jas",S17),
socialNetworkToString(S17,S18),write(S18).
--------------- Ejemplo 2 ----------------------
date(05,10,2021,D1),socialNetwork("Facebook",D1,S1),socialNetworkRegister(S1,"25-05-202","luis","jas",S2),
socialNetworkRegister(S2,"22-03-2020","Carlos","sds",S3),socialNetworkRegister(S3,"22-03-2020","Javiera","hola",S4),
socialNetworkLogin(S4,"luis","jas",S5),
socialNetworkPost(S5,D1,"PRIMER POST",["Carlos","Javiera"],S6),socialNetworkLogin(S6,"Carlos","sds",S7),
socialNetworkPost(S7,D1,"SegundoPost",[],S8),socialNetworkLogin(S8,"luis","jas",S9),
socialNetworkShare(S9,D1,2,["Carlos"],S10),socialNetworkLogin(S10,"luis","jas",S11),
socialNetworkFollow(S11,"Carlos",S12),socialNetworkLogin(S12,"luis","jas",S13),socialNetworkFollow(S13,"Javiera",S14),
socialNetworkLogin(S14,"luis","jas",S15),
socialNetworkPost(S15,D1,"TERCER POST",[],S16),socialNetworkLogin(S16,"luis","jas",S17),
socialNetworkToString(S17,S18),write(S18),getPost(S16,Post),getShare(S16,Share).

------------------Ejemplo 3 ----------------------
date(05,10,2021,D1),socialNetwork("Facebook",D1,S1),socialNetworkRegister(S1,"25-05-202","luis","jas",S2),
socialNetworkRegister(S2,"22-03-2020","Carlos","sds",S3),socialNetworkRegister(S3,"22-03-2020","Javiera","hola",S4),
socialNetworkLogin(S4,"luis","jas",S5),
socialNetworkPost(S5,D1,"PRIMER POST",["Carlos","Javiera"],S6),socialNetworkLogin(S6,"Carlos","sds",S7),
socialNetworkPost(S7,D1,"SegundoPost",[],S8),socialNetworkLogin(S8,"luis","jas",S9),
socialNetworkShare(S9,D1,2,["Carlos"],S10),socialNetworkLogin(S10,"luis","jas",S11),
socialNetworkFollow(S11,"Carlos",S12),socialNetworkLogin(S12,"luis","jas",S13),socialNetworkFollow(S13,"Javiera",S14),
socialNetworkLogin(S14,"luis","jas",S15),
socialNetworkPost(S15,D1,"TERCER POST",[],S16),socialNetworkLogin(S16,"luis","jas",S17),
socialNetworkToString(S17,S18),write(S18),getPost(S16,Post),getShare(S16,Share).

*/

