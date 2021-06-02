
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

registroUsuario(NameU,Password,Registro):-
    Registro = [NameU,Password].



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




socialNetworkRegister(SocialNet,Name,Password,SocialNet2):-
    getName(SocialNet,NombreRed),
    getDate(SocialNet,Fecha),
    getRegister(SocialNet,Registro),
    registroUsuario(Name,Password,ListaUsuario),
    socialNetwork(NombreRed,Fecha,SocialNet2),
    getRegister(SocialNet2,Registro2),
    append(Registro2,ListaUsuario,SocialNet2).
socialNetworkRegister(SocialNet,Name,Password,SocialNet2):-
    getRegister(SocialNet,Registro),
    getName(SocialNet,NombreRed),
    getDate(SocialNet,Date),
    not(elementoEnLista(Registro,Name)),
    registroUsuario(Name,Password,ListaUsuario),
    socialNetwork(NombreRed,Date,SocialNet2),
    getRegister(SocialNet,Registro2),
    append(Registro2,ListaUsuario,SocialNet2).




 %----------------
 /* FunciÃ³n elementoEnLista: Verifica si un elemento esta en la lista.
 * Dominio: Lista x elemento
 * Recorrido: Booleano
 */
elementoEnLista([],_):- false, !.
elementoEnLista([[X|_]|Y],Elemento):- X = Elemento; elementoEnLista(Y,Elemento).
