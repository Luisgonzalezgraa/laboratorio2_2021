
/*TDA socialNetwork: Lista con el nombre de la red social y la fecha de creacion que es tipo TDA date.
 * [Name,[RegistroUsuarios],[Publicaciones],[Seguidos],[Compartidos],[date]].
 * Name = string. date = lista de enteros.
*/
socialNetwork(Name,Date,SOut):-
    SOut = [Name,Date,[],[],[],[],[],[]].


/*TDA socialNetwork: Lista de enteros con el dia el mes y el a�o.
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
getComment([_|[_|[_|[_|[_|[_|[_|[Comment|_]]]]]]]],Comment).




%-------------------------------------
%############BASE DE CONOCIMIENTOS: RED SOCIAL##################
%socialNetwork("Facebook",[5,10,2020],SocialNetwork1):-
    %SocialNetwork1 = [[["luis","pass"],["karla","pass2"],["javiera","pass3"],["marco","pass4"]],[],[[1,[9,12,2019],"luis","primer post para todos",[]],[2,[9,12,2019],"luis","post para karla y javiera",[karla,javiera]],[3,[9,12,2019],"karla","primer post para luis",[luis]]],[["luis"," sigue a","karla"]],[["luis", "\n      sigue a: ", ["karla", "javiera"]], ["javiera", "\n      sigue a: ", ["luis"]]],[[1, "luis", "primer post para todos", "Compartido: \n", [5, "/", 10,"/",2021], "javiera", ["karla"]]]].
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
    getComment(ListaI,Comment),
    Registro == [],
     !,
    Lista2 = [NameSocial,Date,[[Fecha,Name,Password]],UsuarioA,Posteo,Follow,Share,Comment].
socialNetworkRegister(SocialNet,FechaInicio,Name,Password,SocialNet2):-
    getRegister(SocialNet,Registro),
    not(elementoEnLista(Registro,Name)),
    getName(SocialNet,NombreRed),
    getDate(SocialNet,Fecha),
    getUsuarioA(SocialNet,UsuarioA),
    getPost(SocialNet,Posteo),
    getFollow(SocialNet,Follow),
    getShare(SocialNet,Share),
    getComment(SocialNet,Comment),
    registroUsuario(FechaInicio,Name,Password,ListaUsuario),
    append(Registro,[ListaUsuario],Registro2),!,
    SocialNet2 = [NombreRed,Fecha,Registro2,UsuarioA,Posteo,Follow,Share,Comment].


/*----------------------------------------------------------------
Predicado socialNetworkLogin: Verifica si existe el usuario en la
plataforma para poder iniciar su sesion.
Dom: socialNetworw X string X string x socialNetwork
Rec: socialNetworw
Recursion: Natural
Ejemplo de uso:
socialNetworkLogin(SocialNetwork1,"luis","pass",SocialNetwork2).
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
    getComment(SocialNet,Comment),
    append(UsuarioA,["Usuario Activo",Name],UsuarioActivo),!,
    SocialNet2 =[NombreRed,Fecha,Registro,UsuarioActivo,Posteo,Follow,Share,Comment].



/*----------------------------------------------------------------
Predicado socialNetworkPost: Predicado que ayuda a que un usuario con
sesion inicada pueda hacer una publicacion en la plataforma.
Dom: socialNetworw X date X string x list x socialNetwork
Rec: socialNetworw
Recursion:
Natural
Ejemplo de uso:
socialNetworkPost(SocialNet,[10,"/",05,"/",2020],"primer
post",["karla"],SocialNet2).
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
    getComment(SocialNet,Comment),
    SocialNet2 = [NombreRed,FechaS, Registro,[],[[1,Fecha,NombreUsuario,Contenido,ListaUsuarios]],Follow,Share,Comment],!.

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
    getComment(SocialNet,Comment),
    append(Post,[[NumeroFinal,Fecha,NombreUsuario,Contenido,ListaUsuarios]],PostFinal),
    SocialNet2 = [NombreRed,FechaS, Registro,[],PostFinal,Follow,Share,Comment],!.

/*----------------------------------------------------------------
Predicado socialNetworkFollow: Predicado que sirve para que un usuario
con sesion activa en la plataforma, pueda seguir a otro usuario.
Dom: socialNetworw X string X socialNetwork
Rec: socialNetworw
Recursion: Natural
Ejemplo de uso: socialNetworkFollow(SocialNet,"karla",SocialNetwork2).
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
    getComment(SocialNet,Comment),
    SocialNet2 = [NombreRed,FechaS,Registro,[],Post,[[NombreUsuario, "\n      sigue a: ", [Username]]],Share,Comment],!.
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
   getComment(SocialNet,Comment),
   followEnLista(Follow,NombreUsuario,Username,Lista,Pivote),
   getShare(SocialNet,Share),
   Pivote == 1,
   my_last_element(Follow,UltimoFollow),
   my_last_element(UltimoFollow,UltimoSe),
   append(UltimoSe,Lista,SeguidoFinal),
   my_append(UltimoFollow,SeguidoFinal,FollowFinal),
   followRemplazar(Follow,FollowFinal,FollowF),
   SocialNet2 = [NombreRed,FechaS,Register,[],Post,FollowF,Share,Comment],!;
   getFollow(SocialNet,Follow3),
   getName(SocialNet,NombreRed2),
   getDate(SocialNet,FechaS2),
   getPost(SocialNet,Post2),
   getRegister(SocialNet,Register2),
   getUsuarioA(SocialNet,UsuarioA2),
   obtenerCola(UsuarioA2,Cola2),
   obtenerElemento(Cola2,NombreUsuario2),
   getShare(SocialNet,Share2),
   getComment(SocialNet,Comment2),
   Follow1 = [NombreUsuario2,"\n      sigue a: ",[Username]],
   append(Follow3,[Follow1],Follow2),
   SocialNet2 = [NombreRed2,FechaS2,Register2,[],Post2,Follow2,Share2,Comment2],!.



/*----------------------------------------------------------------
Predicado socialNetworkShare: Predicado que permite a un usuario
compartir una publicacion.
Dom: socialNetworw X date X number x list x socialNetwork
Rec: socialNetworw
Recursion: Natural
Ejemplo de uso:
socialNetworkShare(SocialNet,[10,"/",05,"/",2020],2,["luis"],SocialNet2).

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
    getComment(SocialNet,Comment),
    existeContacto(Registro2,Destinatarios),
    getFollow(SocialNet,Follow),
    getUsuarioA(SocialNet,UsuarioA),
    obtenerCola(UsuarioA,Cola),
    obtenerElemento(Cola,NombreUsuario),
    SocialNet2 = [NombreRed,FechaS,Registro,[],Post,Follow,[[Cabeza,NombrePosteador,Publi,"Compartido: \n",Fecha,NombreUsuario,Destinatarios]],Comment],!.
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
    getComment(SocialNet,Comment),
    getUsuarioA(SocialNet,UsuarioA),
    obtenerCola(UsuarioA,Cola),
    obtenerElemento(Cola,NombreUsuario),
    obtenerCabeza(ListaContenidoPost,Cabeza),
    obtenerMedio(ListaContenidoPost,NombrePosteador,Publi),
    ShareF = [Cabeza,NombrePosteador,Publi,"Compartido: \n",Fecha,NombreUsuario,Destinatarios],
    append(Share,[ShareF],ShareFinal),
    SocialNet2 = [NombreRed,FechaS,Registro,[],Post,Follow,ShareFinal,Comment],!.



/*----------------------------------------------------------------
Predicado socialNetworkToString: Predicado que permite visualizar el
contenido de la red social cuando hay un usuario activo y cuando no.
Dom: socialNetworw X socialNetwork
Rec: socialNetworw
Recursion: Natural
Ejemplo de uso: socialNetworkToString(SocialNet,SocialNet2).
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
    getComment(SocialNet,Comment),
    lista2String(Date,DateString),
    string_concat("\n#### Nombre de la red social: ",NombreRed,String1),string_concat(String1," ####\n",String2),
    string_concat(String2,"####Creaci�n de la red social: ",String3),string_concat(String3,DateString,String4),
    string_concat(String4,"####\n",String5),
    string_concat(String5,"*** Usuarios Registrados ***\n",String6),
    register2String(Follow,Follow2,Register2,RegisterString),
    string_concat(String6,RegisterString,String7),
    string_concat(String7,"------------------------------------------------\n",String8),
    string_concat(String8,"**************PUBLICACIONES*********************\n",String9),
    post2String(Post,Share,PostString),
    string_concat(String9,PostString,String10),
    string_concat(String10,"*************FIN PUBLICACIONES*****************\n",String11),
    string_concat(String11,"------------------------------------------------\n",String12),
    string_concat(String12,"**************COMENTARIOS*********************\n",String13),
    comment2String(Comment,StringL),
    string_concat(String13,StringL,String14),
    string_concat(String14,"*************FIN COMENTARIOS*****************\n",SocialNet2),
    !.

socialNetworkToString(SocialNet,SocialNet2):-
    getUsuarioA(SocialNet,UsuarioA),
    obtenerCola(UsuarioA,NombreUsuario),
    obtenerElemento(NombreUsuario,Usuario),
    getName(SocialNet,NombreRed),
    getDate(SocialNet,Date),
    getFollow(SocialNet,Follow),
    getPost(SocialNet,Post),
    getShare(SocialNet,Share),
    getComment(SocialNet,Comment),
    lista2String(Date,DateString),
    string_concat("\n#### Nombre de la red social: ",NombreRed,String1),string_concat(String1," ####\n",String2),
    string_concat(String2,"####Creaci�n de la red social: ",String3),string_concat(String3,DateString,String4),
    string_concat(String4,"####\n",String5),
    string_concat(String5,"*** Usuarios Con sesi�n iniciada ***\n",String6),
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
    string_concat(String15,"------------------------------------------------\n",String16),
    string_concat(String16,"**************COMENTARIOS*********************\n",String17),
    comment2String2(Comment,Usuario,StringList),
    string_concat(String17,StringList,String18),
    string_concat(String18,"**************FIN COMENTARIOS*********************\n",SocialNet2),
    !.





/* ------------------------------------------------------------------------
Predicado socialNetworkToString: Predicado que permite visualizar el
contenido de la red social cuando hay un usuario activo y cuando no.
Dom: socialNetworw X socialNetwork
Rec: socialNetworw
Recursion: Natural
Ejemplo de uso: socialNetworkToString(SocialNet,SocialNet2).
 */
comment(SocialNet, Fecha, PostId, CommentId, TextoComentario, SocialNet2):-
    getComment(SocialNet,Comment),
    CommentId == 0,
    Comment == [],
    !,
    getName(SocialNet,NombreRed),
    getDate(SocialNet,FechaS),
    getRegister(SocialNet,Registro),
    getPost(SocialNet,Post),
    getFollow(SocialNet,Follow),
    getShare(SocialNet,Share),
    getUsuarioA(SocialNet,UsuarioA),
    obtenerCola(UsuarioA,Cola),
    obtenerElemento(Cola,NombreUsuario),
    idEnLista(Post,PostId,ListaContenidoPost),
    obtenerCabeza(ListaContenidoPost,Cabeza),
    obtenerMedio(ListaContenidoPost,NombrePosteador,Publi),
    Lista = [Cabeza,Publi,NombrePosteador,1,NombreUsuario,Fecha, TextoComentario],
    SocialNet2 = [NombreRed,FechaS,Registro,[],Post,Follow,Share,[Lista]],!.
comment(SocialNet, Fecha, PostId, CommentId, TextoComentario, SocialNet2):-
    getComment(SocialNet,Comment),
    getName(SocialNet,NombreRed),
    getDate(SocialNet,FechaS),
    getRegister(SocialNet,Registro),
    getPost(SocialNet,Post),
    getFollow(SocialNet,Follow),
    getShare(SocialNet,Share),
    getUsuarioA(SocialNet,UsuarioA),
    obtenerCola(UsuarioA,Cola),
    obtenerElemento(Cola,NombreUsuario),
    CommentId == 0,
    idEnLista(Post,PostId,ListaContenidoPost),
    obtenerCabeza(ListaContenidoPost,Cabeza),
    obtenerMedio(ListaContenidoPost,NombrePosteador,Publi),
    my_last_element(Comment,UltimoComment),
    obtenerID(UltimoComment,Numero),
    sumarDosNumeros(Numero,1,NumeroFinal),
    Lista = [Cabeza,Publi,NombrePosteador,NumeroFinal,NombreUsuario,Fecha, TextoComentario],
    append(Comment,[Lista],CommentFinal),
    SocialNet2 = [NombreRed,FechaS,Registro,[],Post,Follow,Share,CommentFinal],
    !;
    getComment(SocialNet,Comment2),
    getName(SocialNet,NombreRed2),
    getDate(SocialNet,FechaS2),
    getRegister(SocialNet,Registro2),
    getPost(SocialNet,Post2),
    getFollow(SocialNet,Follow2),
    getShare(SocialNet,Share2),
    getUsuarioA(SocialNet,UsuarioA2),
    obtenerCola(UsuarioA2,Cola2),
    obtenerElemento(Cola2,NombreUsuario2),
    obtenerIDcomment(Comment2,CommentId,ListaComment),
    obtenerCabeza(ListaComment,NombreUsuari),
    obtenerMedio(ListaComment,_,Comentario),
    my_last_element(Comment2,UltimoComment2),
    obtenerID(UltimoComment2,Numero2),
    sumarDosNumeros(Numero2,1,NumeroFinal2),
    Lista2 = [Numero2,Comentario,NombreUsuari,NumeroFinal2,NombreUsuario2,Fecha,TextoComentario],
    append(Comment2,[Lista2],CommentFinal2),
    SocialNet2 = [NombreRed2,FechaS2,Registro2,[],Post2,Follow2,Share2,CommentFinal2],
    !.









%---------------------------------------------------------------------
 /* Función elementoEnLista: Verifica si un elemento esta en la lista.
 * Dominio: Lista x elemento
 * Recorrido: Booleano
 */
elementoEnLista([],_):- false, !.
elementoEnLista([[_,X,_]|Y],Elemento):- X = Elemento; elementoEnLista(Y,Elemento).

 /* Función shareEnLista: Verifica si un elemento esta en la lista.
 * Dominio: Lista x elemento x string x Lista
 * Recorrido: Lista
 */
shareEnLista([],_,_,_):- false, !.
shareEnLista([[X,_,_,M,N,B,V]|W],Elemento,String,Lista):- X = Elemento,String = M,Lista = [N,B,V]; shareEnLista(W,Elemento,String,Lista).


 /* Función idEnLista: Verifica si un elemento esta en la lista.
 * Dominio: Lista x elemento x Lista
 * Recorrido: Lista
 */
idEnLista([],_,_):- false, !.
idEnLista([[X,_,Z,O,_]|W],Elemento,Lista):- X = Elemento,Lista = [X,Z,O]; idEnLista(W,Elemento,Lista).

 /* Función idEnLista: Verifica si un elemento esta en la lista.
 * Dominio: Lista x elemento x Lista
 * Recorrido: Lista
 */
obtenerID([],_):- false, !.
obtenerID([_,_,_,X,_,_,_],Elemento):- X = Elemento.


/* Función idEnLista: Verifica si un elemento esta en la lista.
 * Dominio: Lista x elemento x Lista
 * Recorrido: Lista
 */
obtenerIDcomment([],_,_):- false, !.
obtenerIDcomment([[_,_,_,X,Y,S,D]|W],Elemento,Lista):- X = Elemento,Lista = [Y,S,D];obtenerIDcomment(W,Elemento,Lista).




 /* Función existeUsuario: Verifica si un usuario esta en la lista.
 * Dominio: Lista x elemento x elemento
 * Recorrido: Booleano
 */
existeUsuario([],_,_):- false, !.
existeUsuario([[_,X,Z]|Y],Elemento,Elemento2):- X = Elemento, Z = Elemento2; existeUsuario(Y,Elemento,Elemento2).

/* Función followEnLista: Verifica si un usuario esta en la lista.
 * Dominio: Lista x elemento x elemento x lista x number
 * Recorrido: number
 */
followEnLista([],_,_,_,Pivote):-!, Pivote is 0.
followEnLista([[Seguidor,_,_]|Cola],NombreUsuario,Seguido2,Lista,Pivote):- Seguidor = NombreUsuario,Lista = [Seguido2],Pivote is 1; followEnLista(Cola,NombreUsuario,Seguido2,Lista,Pivote).


/* Función followRemplazar: Reemplaza un follow si es que existe.
 * Dominio: Lista x Lista X Lista
 * Recorrido: Lista
 */
followRemplazar([],_,_).
followRemplazar(Follow,[[Seguidor2,SigueA,Seguido]],Lista):- my_last_element(Follow,Y),obtenerCabeza(Y,Nombre),Nombre = Seguidor2, my_reverse(Follow,[],Follow2),obtenerCola(Follow2,Cola),Lista2 = [[Seguidor2,SigueA,Seguido]|Cola],my_reverse(Lista2,[],Lista) .




 /* Función obtenerCola: Se obtiene la cola de una lista.
 * Dominio: Lista x elemento
 * Recorrido: elemento
 */
obtenerCola([_|X],Elemento):- X = Elemento,!.

 /* Función obtenerElemento: Se obtiene el elmento de una lista.
 * Dominio: Lista x elemento
 * Recorrido: elemento
 */

obtenerElemento([X],Elemento):- X = Elemento,!.

 /* Función obtenerCabeza: Se obtiene la cabeza de una lista.
 * Dominio: Lista x elemento
 * Recorrido: elemento
 */

obtenerCabeza([X|_],Elemento):- X =Elemento,!.

 /* Función obtenerMedio: Se obtiene la el elemento de al medio y el final de una lista.
 * Dominio: Lista x elemento x elemento
 * Recorrido: elemento
 */

obtenerMedio([_,X,C],Elemento1,Elemento2):- X = Elemento1,C = Elemento2,!.

 /* Función lista2String: convierte los elementos de una lista en string.
 * Dominio: Lista x String
 * Recorrido: String
 */
lista2String([],"").
lista2String([CabezaArch|ColaArch],Lista):-
    string_concat("",CabezaArch,String),lista2String(ColaArch,String2),string_concat(String,String2,Lista).

  /* Función post2String2: Predicado auxiliar que ayuda a socialNetworkToString.
 * Dominio: Lista x String x String
 * Recorrido: String.
[Numero2,Comentario,NombreUsuari,NumeroFinal2,NombreUsuario2,Fecha,TextoComentario]
 */
comment2String(Comment,Lista):-
    Comment == [],
    string_concat("\n","\n",Lista),!.
comment2String([[Numero2,Comentario,NombreUsuari,NumeroFinal2,NombreUsuario2,Fecha,TextoComentario]|Cola],Lista):-
    lista2String(Fecha,Date),
    string_concat("ID al que se comenta: ",Numero2,String),
    string_concat(String,"\nTexto que se comenta: ",String4),string_concat(String4,Comentario,String5),string_concat(String5,"\nNombre Creador: ",String6),
    string_concat(String6,NombreUsuari,String7),string_concat(String7,"\nID comentario: ",String8),
    string_concat(String8,NumeroFinal2,String9),string_concat(String9,"\nNombre del comentarista: ",String10),
    string_concat(String10,NombreUsuario2,String11),string_concat(String11,"\nFecha del Comentario: ",String13),
    string_concat(String13,Date,String14),
    string_concat(String14,"\nComentario: ",String15),string_concat(String15,TextoComentario,String16),string_concat(String16,"\n\n",String17),comment2String(Cola,String18),string_concat(String17,String18,Lista),!.



/* Función post2String2: Predicado auxiliar que ayuda a socialNetworkToString.
 * Dominio: Lista x String x String
 * Recorrido: String.
[Numero2,Comentario,NombreUsuari,NumeroFinal2,NombreUsuario2,Fecha,TextoComentario]
 */
comment2String2(Comment,_,Lista):-
    Comment == [],
    string_concat("\n","\n",Lista),!.
comment2String2([[_,_,_,_,NombreUsuario2,_,_]|Cola],UsuarioActivo,Lista):-
    NombreUsuario2 \= UsuarioActivo,
   comment2String2(Cola,UsuarioActivo,Lista).
comment2String2([[Numero2,Comentario,NombreUsuari,NumeroFinal2,NombreUsuario2,Fecha,TextoComentario]|Cola],Usuario,Lista):-
    lista2String(Fecha,Date),
    NombreUsuario2 == Usuario,
    string_concat("ID al que se comenta: ",Numero2,String),
    string_concat(String,"\nTexto que se comenta: ",String4),string_concat(String4,Comentario,String5),string_concat(String5,"\nNombre Creador: ",String6),
    string_concat(String6,NombreUsuari,String7),string_concat(String7,"\nID comentario: ",String8),
    string_concat(String8,NumeroFinal2,String9),string_concat(String9,"\nNombre del comentarista: ",String10),
    string_concat(String10,NombreUsuario2,String11),string_concat(String11,"\nFecha del Comentario: ",String13),
    string_concat(String13,Date,String14),
    string_concat(String14,"\nComentario: ",String15),string_concat(String15,TextoComentario,String16),string_concat(String16,"\n\n",String17),comment2String2(Cola,Usuario,String18),string_concat(String17,String18,Lista),!.






 /* Función post2String: Predicado auxiliar que ayuda a socialNetworkToString.
 * Dominio: Lista x Lista x String
 * Recorrido: String.

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
    string_concat(String14,"El d�a ",String15),string_concat(String15,DateShare,String16),
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

  /* Función post2String2: Predicado auxiliar que ayuda a socialNetworkToString.
 * Dominio: Lista x String x String
 * Recorrido: String.

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

 /* Función register2String: Predicado auxiliar que ayuda a socialNetworkToString.
 * Dominio: Lista x Lista x Lista x String
 * Recorrido: String.

 */

register2String(_,_,[],"").
register2String([],Follow2,[Cabeza|Colaa],Lista):-
    string_concat(Cabeza,"\n     sigue a: \n",String),string_concat(String,"",String2),string_concat(String2,"\n\n",String3),register2String(Follow2,Follow2,Colaa,String4),string_concat(String3,String4,Lista).
register2String([[NombreSeguidor,_,_]|Cola],Follow2,Register,Lista):-
        obtenerCabeza(Register,Cabeza),
        NombreSeguidor \= Cabeza,
        register2String(Cola,Follow2,Register,Lista).
register2String([[NombreSeguidor,SigueA,NombreSeguid]|ColaA],Follow2,[Cabeza|Colaa],Lista):-
    NombreSeguidor == Cabeza,
    verificarVacio2(NombreSeguid,NombreSeguid,StringDest),
    string_concat(NombreSeguidor,SigueA,String),string_concat(String,StringDest,String2),string_concat(String2,"\n\n",String3),register2String(ColaA,Follow2,Colaa,String4),string_concat(String3,String4,Lista).


  /* Función follow2String2: Predicado auxiliar que ayuda a socialNetworkToString.
 * Dominio: Lista x String x String
 * Recorrido: String.

 */
follow2String2(Follow,_,Lista):-
    Follow == [],
    string_concat("\n","\n",Lista),!.
follow2String2([[Nombre,_,_]|Cola],NombreUsuario,Lista):-
    Nombre \= NombreUsuario,
    follow2String2(Cola,NombreUsuario,Lista).
follow2String2([[Nombre,SigueA,NombreSeguido]|Cola],NombreUsuario,Lista):-
    Nombre == NombreUsuario,
    verificarVacio2(NombreSeguido,NombreSeguido,StringDest),
    string_concat("",SigueA,String),string_concat(String,StringDest,String2),string_concat(String2,"\n\n",String3),follow2String2(Cola,NombreUsuario,String4),string_concat(String3,String4,Lista),!.


  /* Función share2String: Predicado auxiliar que ayuda a socialNetworkToString.
 * Dominio: Lista x String x String
 * Recorrido: String.

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
    string_concat(String3,StringDest,String4),string_concat(String4," la publicaci�n con id ",String5),string_concat(String5,CabezaArch,String6),
    string_concat(String6," de ",String7),string_concat(String7,NombrePublicador,String8),
    string_concat(String8,": ",String9),string_concat(String9,Publicacion,String10),
    string_concat(String10,"\n",String11),string_concat(String11,"\n",String12),share2String(Cola,UsuarioActivo,String13),string_concat(String12,String13,Lista),!.


 /* Función verificarVacio: Verifica un elemento si no se encuentra nada retorna " Todos".
 * Dominio: Lista x Lista x String
 * Recorrido: String
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

  /* Función verificarVacio2: Verifica un elemento y concatena los que existe en la lista en un string.
 * Dominio: Lista x Lista x String
 * Recorrido: String
 */

verificarVacio2(ListaI,Igual,ListaF):-
    Igual == [],
    ListaI == [],
    !,
    string_concat(""," ",ListaF),!.
verificarVacio2(ListaI,_,ListaF):-
    ListaI == [],
    string_concat("","",ListaF),!.
verificarVacio2([Cabeza|Cola],Igual,ListaF):-
    string_concat(Cabeza," ",String),verificarVacio2(Cola,Igual,String2),string_concat(String,String2,ListaF),!.



 /* Función existeContacto: Verifica si un contacto esta en la lista.
 * Dominio: Lista x Lista
 * Recorrido: Booleano
 */
existeContacto(_,[]):- !.
existeContacto(Usuarios,[C|T]):-
    member(C,Usuarios),
    existeContacto(Usuarios,T),!.

 /* Función getUsers: Se obtiene una lista de usuarios de una lista de listas.
 * Dominio: Lista x Lista x Lista
 * Recorrido: Lista
 */
getUsers([],Lista,Lista).
getUsers([[_,User,_]|Us],Lista,[User|Resultado]):-
	getUsers(Us,Lista,Resultado).

 /* Función sumarDosNumeros: se suman dos numeros.
 * Dominio: number x number x number
 * Recorrido: number
 */
sumarDosNumeros(X,Y,Z):- Z is X + Y.

 /* Función my_last_element: Se obtiene el ultimo elemento de una lista.
 * Dominio: Lista x Lista
 * Recorrido: Lista
 */
my_last_element([Y], Y).

my_last_element([_|Xs], Y):-
          my_last_element(Xs, Y).

 /* Función my_append: Agrega un elemento nuevo al final de la lista.
 * Dominio: Lista x Lista x Lista
 * Recorrido: Lista
 */
my_append([NombreSegui,SigueA,_], Lista,ListaFinal):-
    ListaFinal = [[NombreSegui,SigueA,Lista]].


 /* Función my_reverse: Se invierte una lista.
 * Dominio: Lista x Lista x Lista
 * Recorrido: Lista
 */

my_reverse([], Zs, Zs).

my_reverse([X|Xs], Ys, Zs):-
          my_reverse(Xs, [X|Ys], Zs).

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

