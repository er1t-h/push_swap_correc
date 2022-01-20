# push_swap_correc

## Utilisation des scripts

### `tester.sh`

`tester.sh` effectue 100 fois push_swap avec 100 nombres, affiche la moyenne, le pire cas et ses arguments ainsi que le meilleur cas et ses arguments.  
Il peut aussi prendre ces valeurs en argument comme suit :
```sh
./tester.sh [nombre de répétition] [nombre de valeurs]
```
Par ailleurs, à la fin de son exécution, il copiera les pires valeurs, donc vous pouvez directement faire `Ctrl+V` pour lles utiliser (et les meilleurs valeurs sont dans le clic molette)
--------
### `push_swap_complete_correction.sh`

Il permet de faire toutes sortes de tests, très pratique pour une correction. Vous pouvez changer les quelques valeurs en haut du fichier pour l'adapter à vos besoins (utilisation de valgrind, évaluation des bonus, etc...)  
Il test des mauvais inputs, des combinaisons de 2, 3, 5 (en testant les limites demandées dans le sujet), 100 et 500 nombres (en affichant la moyenne, le pire et le meilleur cas)  
Il fait aussi quelques tests sur valgrind pour s'assurer qu'il n'y a pas de leaks.
```sh
./push_swap_complete_correction.sh
```
