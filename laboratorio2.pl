
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

%----------------------------------------------------------------------

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





 %----------------
 /* Función elementoEnLista: Verifica si un elemento esta en la lista.
 * Dominio: Lista x elemento
 * Recorrido: Booleano
 */
elementoEnLista([],_):- false, !.
elementoEnLista([[_,X,_]|Y],Elemento):- X = Elemento; elementoEnLista(Y,Elemento).

existeUsuario([],_,_):- false, !.
existeUsuario([[_,X,Z]|Y],Elemento,Elemento2):- X = Elemento, Z = Elemento2; existeUsuario(Y,Elemento,Elemento2).





