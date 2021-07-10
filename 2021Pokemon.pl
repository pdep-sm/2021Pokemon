% pokemon(tipo, cadena de evolución, condiciones de evolución)
pokemon(dragon, [dratini, dragonair, dragonite], [nivel(30), nivel(55)]).
pokemon(electrico, [pichu, pikachu, raichu], [alegria, piedra]).
pokemon(fuego, [charmander, charmeleon, charizard], [nivel(16), nivel(36)]).
pokemon(pelea, [tyrogue, hitmonchan], [nivel(20)]).
pokemon(pelea, [tyrogue, hitmonlee], [nivel(20)]).
pokemon(normal, [snorlax], []).
pokemon(normal, [rattata, raticate], [nivel(20)]).
pokemon(agua, [staryu, starmie], [piedra]).
pokemon(agua, [psyduck, golduck], [nivel(33)]).
pokemon(tierra, [sandshrew, sandslash], [nivel(22)]).
pokemon(roca, [aerodactyl], []).
pokemon(roca, [onix], []). 
pokemon(fantasma, [gastly, haunter, gengar], [nivel(25), intercambio]).

% inmune(tipo inmune, tipo contrario)
inmune(tierra, electrico).
inmune(fantasma, pelea).
inmune(fantasma, normal).
inmune(normal, fantasma).

% fuerteContra(tipo fuerte, tipo contrario)
fuerteContra(pelea, normal).
fuerteContra(pelea, roca).
fuerteContra(electrico, agua).
fuerteContra(fantasma, fantasma).
fuerteContra(tierra, roca).
fuerteContra(roca, normal).
fuerteContra(agua, fuego).

% entrenador(nombre, pokebolas, elemento)
% pokebola(pokemon, nivel)
entrenador(ash, 
    [pokebola(snorlax, 55), pokebola(pikachu, 70), 
    pokebola(rattata, 50), pokebola(charmander, 60)], piedra).
entrenador(misty, [pokebola(staryu, 60), pokebola(psyduck, 34)], medalla).
entrenador(brock, [pokebola(hitmonchan, 58), pokebola(onix, 60)], piedra).
entrenador(lance, [pokebola(dragonite, 80), pokebola(aerodactyl, 70)], medalla).

%1
tipo(Pokemon, Tipo):-
    pokemon(Tipo, Pokemones, _ ),
    member(Pokemon, Pokemones).
tipo(pokebola(Pokemon, _ ), Tipo):-
    tipo(Pokemon, Tipo).

%2
entrenadorGroso(Entrenador):-
    entrenador(Entrenador, Pokebolas, _ ),
    member(Pokebola, Pokebolas),
    esGrosa(Pokebola).
esGrosa(pokebola(Pokemon, _ )):-
    tipo(Pokemon, dragon).
esGrosa(pokebola( _ , Nivel)):-
    Nivel > 65.

%3
/*
pokemonFavorito(Entrenador, Pokemon):-
    entrenador(Entrenador, Pokebolas, _ ),
    member(pokebola(Pokemon, Nivel), Pokebolas),
    not((member(pokebola(_, OtroNivel), Pokebolas), OtroNivel > Nivel)).
*/
pokemonFavorito(Entrenador, Pokemon):-
    entrenador(Entrenador, Pokebolas, _ ),
    member(pokebola(Pokemon, Nivel), Pokebolas),
    forall(member(pokebola(_, OtroNivel), Pokebolas), Nivel >= OtroNivel).

%4
puedeEvolucionar(Entrenador, Pokebola):-
    entrenadorPokebola(Entrenador, Pokebola),
    pokemon(Pokebola, Pokemon),
    condicionDeEvolucion(Pokemon, Condicion),
    cumpleCondicionDeEvolucion(Condicion, Entrenador, Pokebola).

entrenadorPokebola(Entrenador, Pokebola):-
    entrenador(Entrenador, Pokebolas, _ ),
    member(Pokebola, Pokebolas).

condicionDeEvolucion(Pokemon, Condicion):-
    pokemon(_, Pokemones, Condiciones),
    nth1(Indice, Pokemones, Pokemon),
    nth1(Indice, Condiciones, Condicion).

cumpleCondicionDeEvolucion(nivel(NivelCondicion), _ , pokebola(_, NivelPokemon)):-
    NivelPokemon >= NivelCondicion.
cumpleCondicionDeEvolucion(alegria, Entrenador, pokebola(Pokemon, _ )):-
    pokemonFavorito(Entrenador, Pokemon).
cumpleCondicionDeEvolucion(Elemento, Entrenador, _ ):-
    entrenador(Entrenador, _ , Elemento).
/*
puedeEvolucionar(Entrenador, Pokebola):-
    entrenador(Entrenador, Pokebolas, _ ),
    member(Pokebola, Pokebolas),
    nivel(Pokebola, Pokemon, NivelPokemon),
    pokemon(_, Pokemones, Condiciones),
    nth1(Indice, Pokemon, Pokemones),
    nth1(Indice, nivel(NivelCondicion), Condiciones),
    NivelPokemon >= NivelCondicion.
*/
pokemon(Pokebola, Pokemon):- nivel(Pokebola, Pokemon, _ ).
nivel(Pokebola, Nivel):- nivel(Pokebola, _ , Nivel).
nivel(pokebola(Pokemon, NivelPokemon), Pokemon, NivelPokemon).

%5
pokemonAburrido(Pokemon):-
    pokemon( _ , [Pokemon], _ ).
pokemonAburrido(Pokemon):-
    tipo(Pokemon, normal).

%6
leConvienePelear(Pokebola1, Pokebola2):-
    tipo(Pokebola1, Tipo1),
    tipo(Pokebola2, Tipo2),
    not(inmune(Tipo2, Tipo1)),
    tieneVentaja(Pokebola1, Pokebola2).

tieneVentaja(Pokebola1, Pokebola2):-
    tipo(Pokebola1, Tipo1),
    tipo(Pokebola2, Tipo2),
    inmune(Tipo1, Tipo2).
tieneVentaja(Pokebola1, Pokebola2):-
    tipo(Pokebola1, Tipo1),
    tipo(Pokebola2, Tipo2),
    fuerteContra(Tipo1, Tipo2).
tieneVentaja(Pokebola1, Pokebola2):-
    tipo(Pokebola1, Tipo1),
    tipo(Pokebola2, Tipo2),
    not(fuerteContra(Tipo2, Tipo1)),
    nivel(Pokebola1, Nivel1),
    nivel(Pokebola2, Nivel2),
    Nivel1 > Nivel2.

%7
tieneVariedad(Entrenador):-
    tipos(Entrenador, Tipos),
    length(Tipos, Cantidad),
    Cantidad >= 3.

tipos(Entrenador, Tipos):-
    entrenador(Entrenador, Pokebolas, _ ),
    findall(Tipo, 
        (member(Pokebola, Pokebolas), tipo(Pokebola, Tipo)), 
        TiposRepetidos),    
    list_to_set(TiposRepetidos, Tipos).

%8
entrenadorFanatico(Entrenador):-
    entrenadorPokebola(Entrenador, Pokebola),
    tipo(Pokebola, Tipo),
    /*entrenador(Entrenador, [_,_|_] , _ ),*/
    entrenador(Entrenador, Pokebolas, _ ),
    length(Pokebolas, Cantidad),
    Cantidad > 1,
    /**/
    /*tipos(Entrenador, [Tipo]),*/
    forall(entrenadorPokebola(Entrenador, OtraPokebola), tipo(OtraPokebola, Tipo))
    /**/.



% pokebola(Pokemon, _ )


:- begin_tests(pokemon).

%1
test(dragoniteEsTipoDragon):-
    tipo(dragonite, dragon).
test(dragoniteNoEsTipoFuego, fail):-
    tipo(dragonite, fuego).

%2
test(lanceEsEntrenadorGroso, nondet):-
    entrenadorGroso(lance).
test(ashEsEntrenadorGroso, nondet):-
    entrenadorGroso(ash).
test(mistyNoEsEntrenadoraGrosa, fail):-
    entrenadorGroso(misty).

%3
test(pikachuEsElFavoritoDeAsh, nondet):-
    pokemonFavorito(ash, pikachu).
test(rattataNoEsElFavoritoDeAsh, fail):-
    pokemonFavorito(ash, rattata).

:- end_tests(pokemon).


