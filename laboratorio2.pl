
/*TDA socialNetwork: Lista con el nombre de la red social y la fecha de creacion que es tipo TDA date.
 * [Name,[RegistroUsuarios],[Publicaciones],[Seguidos],[Compartidos],[date]].
 * Name = string. date = lista de enteros.
*/
socialNetwork(Name,Date,SOut):-
    SOut = [Name,Date,[],[],[],[]].


/*TDA socialNetwork: Lista de enteros con el dia el mes y el año.
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
getPost([_|[_|[_|[Post|_]]]],Post).
getFollow([_|[_|[_|[_|[Follow|_]]]]],Follow).
getShare([_|[_|[_|[_|[_|[Share|_]]]]]],Share).

%selectores TDA registroUsuario.
getNameU([NameU|_],NameU).
getPassword([_|[Password|_]],Password).



socialNetworkRegister(ListaI,Fecha,Name,Password,Lista2):-
    getRegister(ListaI,Registro),
    getName(ListaI,NameSocial),
    getDate(ListaI,Date),
    Registro == [],
     !,
    true,
    Lista2 = [NameSocial,Date,[[Fecha,Name,Password]],[],[],[]],
    true.
socialNetworkRegister(SocialNet,FechaInicio,Name,Password,SocialNet2):-
    getRegister(SocialNet,Registro),
    not(elementoEnLista(Registro,Name)),
    getName(SocialNet,NombreRed),
    getDate(SocialNet,Fecha),
    registroUsuario(FechaInicio,Name,Password,ListaUsuario),
    append(Registro,[ListaUsuario],Registro2),!,
    SocialNet2 = [NombreRed,Fecha,Registro2,[],[],[]],
    true.



 %----------------
 /* FunciÃ³n elementoEnLista: Verifica si un elemento esta en la lista.
 * Dominio: Lista x elemento
 * Recorrido: Booleano
 */
elementoEnLista([],_):- false, !.
elementoEnLista([[_,X,_]|Y],Elemento):- X = Elemento; elementoEnLista(Y,Elemento).
%---------------------
/* Funcion auxRegis: Añade el usuario nuevo a la lista de usuarios con su respectiva contraseña.
 * Dominio: Lista x Lista
 * Recorrido: Lista
 */

auxRegis(Usuario,[],Usuario):-!.
auxRegis(Lista,[CabezaUsu|ColaF],ListaSalida):-
        auxRegis2(Lista,[CabezaUsu|ColaF],ListaSalida),!.

/* Funcion auxRegis2: Revisa si un elemento esta en la lista, si no esta lo añade, de lo contrario responde con un false.
 * Dominio: Lista x String
 * Recorrido: Lista or false.
 */

auxRegis2(ListaM,[Cabeza|Cola],ListaActualizado):-
    getName(ListaM,Lista),
    not(elementoEnLista(Lista,Cabeza)),
    agregarElemento(ListaM,[Cabeza|Cola],ListaActualizado),!.


agregarElemento(Lista,Elemento,ListaNueva):-
   append(Lista,[Elemento],ListaNueva).


