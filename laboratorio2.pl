
/*TDA socialNetwork: Lista con el nombre de la red social y la fecha de creacion que es tipo TDA date.
 * [Name,[RegistroUsuarios],[Publicaciones],[Seguidos],[Compartidos],[date]].
 * Name = string. date = lista de enteros.
*/
socialNetwork(Name,Date,SOut):-
    SOut = [Name,Date,[],[],[],[],[]].


/*TDA socialNetwork: Lista de enteros con el dia el mes y el a�o.
 * [Name,[date]].
 * Name = string.
 * date = lista de enteros.
*/
date(Day,Month,Year,OutDate):-
     OutDate = [Day,Month,Year].

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
socialNetworkPos(SocialNet,_,_,_,_):-
    getUsuarioA(SocialNet,UsuarioA),
    UsuarioA == [],
    !,
    false.
socialNetworkPost(SocialNet,Fecha,Contenido,ListaUsuarios,SocialNet2):-
    getPost(SocialNet,Post),
    Post == [],
    !,
    getRegister(SocialNet,Registro),
    getUsers(Registro,[],Registro2),
    existeContacto(Registro2,UsuarioA),
    obtenerCola(UsuarioA,NombreUsuario),
    getName(SocialNet,NombreRed),
    getDate(SocialNet,FechaS),
    getFollow(SocialNet,Follow),
    getShare(SocialNet,Share),
    SocialNet2 = [NombreRed,FechaS, Registro,[],[[Fecha,NombreUsuario,Contenido,ListaUsuarios]],Follow,Share],!.

socialNetworkPost(SocialNet,Fecha,Contenido,ListaUsuarios,SocialNet2):-
    getRegister(SocialNet,Registro),
    getUsers(Registro,[],Registro2),
    existeContacto(Registro2,ListaUsuarios),
    getUsuarioA(SocialNet,UsuarioA),
    getPost(SocialNet,Post),
    obtenerCola(UsuarioA,NombreUsuario),
    getRegister(SocialNet,Registro),
    getName(SocialNet,NombreRed),
    getDate(SocialNet,FechaS),
    getFollow(SocialNet,Follow),
    getShare(SocialNet,Share),
    append(Post,[[Fecha,NombreUsuario,Contenido,ListaUsuarios]],PostFinal),
    SocialNet2 = [NombreRed,FechaS, Registro,[],PostFinal,Follow,Share].


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
    SocialNet2 = [NombreRed,FechaS,Registro,[],Post,[[NombreUsuario, "Ahora sigue A ", Username]],Share],!.
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
   append(Follow,[[NombreUsuario, " Ahora sigue A ",Username]],Follow2),
   SocialNet2 = [NombreRed,FechaS,Register,[],Post,Follow2,Share],!.





 /* Función elementoEnLista: Verifica si un elemento esta en la lista.
 * Dominio: Lista x elemento
 * Recorrido: Booleano
 */
elementoEnLista([],_):- false, !.
elementoEnLista([[_,X,_]|Y],Elemento):- X = Elemento; elementoEnLista(Y,Elemento).

existeUsuario([],_,_):- false, !.
existeUsuario([[_,X,Z]|Y],Elemento,Elemento2):- X = Elemento, Z = Elemento2; existeUsuario(Y,Elemento,Elemento2).


obtenerCola([_|X],Elemento):- X = Elemento,!.
obtenerElemento([X],Elemento):- X = Elemento,!.



existeContacto(_,[]):- !.
existeContacto(Usuarios,[C|T]):-
    member(C,Usuarios),
    existeContacto(Usuarios,T),!.

getUsers([],Lista,Lista).
getUsers([[_,User,_]|Us],Lista,[User|Resultado]):-
	getUsers(Us,Lista,Resultado).

