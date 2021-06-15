
/*TDA socialNetwork: Lista con el nombre de la red social y la fecha de creacion que es tipo TDA date.
 * [Name,[RegistroUsuarios],[Publicaciones],[Seguidos],[Compartidos],[date]].
 * Name = string. date = lista de enteros.
*/
socialNetwork(Name,Date,SOut):-
    SOut = [Name,Date,[],[],[],[],[]].


/*TDA socialNetwork: Lista de enteros con el dia el mes y el año.
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
    %SocialNetwork1 = [[["luis","pass"],["karla","pass2"],["javiera","pass3"],["marco","pass4"]],[],[[[9,12,2019],"luis","primer post para todos",[]],[[9,12,2019],"luis","post para karla y javiera",[karla,javiera]],[[9,12,2019],"karla","primer post para luis",[luis]]],[["luis","Ahora sigue A","karla"]],[]].
%-------------------------------------

%-----------------------------------------------------------------

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

% ------------------------------------------------------------------------


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



% ------------------------------------------------------------------------

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


 %--------------------------------------------------------------------------------

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
    SocialNet2 = [NombreRed,FechaS,Registro,[],Post,[[NombreUsuario, "\n      Ahora sigue a: ", Username]],Share],!.
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
   append(Follow,[[NombreUsuario, "\n      Ahora sigue a: ",Username]],Follow2),
   SocialNet2 = [NombreRed,FechaS,Register,[],Post,Follow2,Share],!.

% -----------------------------------------------------------------------
%
socialNetworkShare(SocialNet,Fecha,PostId,Destinatarios,SocialNet2):-
    getShare(SocialNet,Share),
    getPost(SocialNet,Post),
    idEnLista(Post,PostId,ListaContenidoPost),
    Share == [],
    !,
    getName(SocialNet,NombreRed),
    obtenerCabeza(ListaContenidoPost,Cabeza),
    obtenerCola(ListaContenidoPost,ColaU),
    getDate(SocialNet,FechaS),
    getRegister(SocialNet,Registro),
    getUsers(Registro,[],Registro2),
    existeContacto(Registro2,Destinatarios),
    getFollow(SocialNet,Follow),
    getUsuarioA(SocialNet,UsuarioA),
    obtenerCola(UsuarioA,Cola),
    obtenerElemento(Cola,NombreUsuario),
    obtenerElemento(ColaU,Publi),
    SocialNet2 = [NombreRed,FechaS,Registro,[],Post,Follow,[[Cabeza,Publi,"->",[Fecha,NombreUsuario,Destinatarios]]] ],!.
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
    obtenerCola(ListaContenidoPost,ColaU),
    obtenerElemento(ColaU,Publi),
    Lista2 = [Fecha,NombreUsuario,Destinatarios],
    ShareF = [Cabeza,Publi,"->",Lista2],
    append(Share,[ShareF],ShareFinal),
    SocialNet2 = [NombreRed,FechaS,Registro,[],Post,Follow,ShareFinal],!.



% ------------------------------------------------------------------------


socialNetworkToString(SocialNet,SocialNet2):-
    getUsuarioA(SocialNet,UsuarioA),
    UsuarioA == [],
    getName(SocialNet,NombreRed),
    getDate(SocialNet,Date),
    getRegister(SocialNet,Register),
    getFollow(SocialNet,Follow),
    lista2String(Date,DateString),
    string_concat("\n#### Nombre de la red social: ",NombreRed,String1),string_concat(String1," ####\n",String2),
    string_concat(String2,"####Creación de la red social: ",String3),string_concat(String3,DateString,String4),
    string_concat(String4,"####\n",String5),
    string_concat(String5,"*** Usuarios Registrados ***\n",String6),
    register2String(Register,Follow,RegisterString),
    string_concat(String6,RegisterString,String7),
    string_concat(String7,"------------------------------------------------\n",String8),
    string_concat(String8,"**************PUBLICACIONES*********************\n",String9).










 /* FunciÃ³n elementoEnLista: Verifica si un elemento esta en la lista.
 * Dominio: Lista x elemento
 * Recorrido: Booleano
 */
elementoEnLista([],_):- false, !.
elementoEnLista([[_,X,_]|Y],Elemento):- X = Elemento; elementoEnLista(Y,Elemento).

followEnLista([],_,_):- false, !.
followEnLista([[X,Y,Z]|W],Elemento,Lista):- X = Elemento,Lista = [X,Y,Z]; followEnLista(W,Elemento,Lista).


idEnLista([],_,_):- false, !.
idEnLista([[X,_,Z,O,_]|W],Elemento,Lista):- X = Elemento,Lista = [Z,O]; idEnLista(W,Elemento,Lista).


existeUsuario([],_,_):- false, !.
existeUsuario([[_,X,Z]|Y],Elemento,Elemento2):- X = Elemento, Z = Elemento2; existeUsuario(Y,Elemento,Elemento2).


obtenerCola([_|X],Elemento):- X = Elemento,!.
obtenerElemento([X],Elemento):- X = Elemento,!.
obtenerCabeza([X|_],Elemento):- X =Elemento,!.
obtenerMedio([_,X,C],Elemento1,Elemento2):- X = Elemento1,C = Elemento2,!.


lista2String([],"").
lista2String([CabezaArch|ColaArch],Lista):-
    string_concat("",CabezaArch,String),lista2String(ColaArch,String2),string_concat(String,String2,Lista).


register2String([],_,""):-!.
register2String([[_,CabezaArch,_|_]|ColaArch],Follow,Lista):-
    Follow == [],
    string_concat(CabezaArch,"\n      Ahora sigue a: \n",String),register2String(ColaArch,Follow,String2),string_concat(String,String2,Lista),!.
register2String([[_,CabezaArch,_]|ColaArch],Follow,Lista):-
    followEnLista(Follow,CabezaArch,ListaFollow),
    obtenerCabeza(ListaFollow,X),
    obtenerMedio(ListaFollow,Y,Z),
    string_concat(X,Y,String),string_concat(String,Z,String2),string_concat(String2,"\n\n",String3),register2String(ColaArch,Follow,String4),string_concat(String3,String4,Lista),!;
    string_concat(CabezaArch,"\n      Ahora sigue a: \n",Strings),register2String(ColaArch,Follow,Strings2),string_concat(Strings,Strings2,Lista),!.

post2String([],_,""):-!.
post2String([],Post,Lista):-
    Post == [],
    string_concat("\nSin Publicaciones.","\n****Fin Publicaciones*******\n",Lista),!.
post2String([[_,CabezaArch,_]|ColaArch],Follow,Lista):-
    followEnLista(Follow,CabezaArch,ListaFollow),
    obtenerCabeza(ListaFollow,X),
    obtenerMedio(ListaFollow,Y,Z),
    string_concat(X,Y,String),string_concat(String,Z,String2),string_concat(String2,"\n\n",String3),post2String(ColaArch,Follow,String4),string_concat(String3,String4,Lista),!;
    string_concat(CabezaArch,"\n      Ahora sigue a: \n",Strings),post2String(ColaArch,Follow,Strings2),string_concat(Strings,Strings2,Lista),!.



existeContacto(_,[]):- !.
existeContacto(Usuarios,[C|T]):-
    member(C,Usuarios),
    existeContacto(Usuarios,T),!.

getUsers([],Lista,Lista).
getUsers([[_,User,_]|Us],Lista,[User|Resultado]):-
	getUsers(Us,Lista,Resultado).

sumarDosNumeros(X,Y,Z):- Z is X + Y.

my_last_element([Y], Y).

my_last_element([_|Xs], Y):-
          my_last_element(Xs, Y).
