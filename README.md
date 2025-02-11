# Optimal_Kidney_Exchange

## 1 - Contexte

Malgré l'augmentation croissante du nombre de transplantations d'organes effectuées chaque année (environ 6000 en 2017 dont 3782 transplantations de reins), la demande reste en perpétuelle augmentation. Ainsi 6000 organes, dont 3782 reins, ont été transplantés en 2017, mais il y avait encore 24000 personnes en attente d'un organe la même année. Les organes transplantés peuvent provenir d'un donneur décédé ou, dans le cas des reins et du foie, d'un donneur vivant consentant, le plus souvent membre de la famille du patient. 

Hélas, même si un proche accepte de prendre ce risque pour sa santé, il ne sera pas forcément compatible avec le patient. Pour cette raison, les pratiques médicales et les législations évoluent dans de nombreux pays afin de permettre la mise en place d'un programme d'échange de dons d'organes. 

L'exemple le plus simple d'échange de don d'organes est celui où deux patients $P_1$ et $P_2$ sont accompagnés de donneurs $D_1$ et $D_2$. Les patients sont supposés incompatibles avec les donneurs qui les accompagnent, mais on suppose que $D_1$ est compatible avec $P_2$ et $D_2$ avec $P_1$. Il est alors possible de transplanter un organe de $D_1$ vers $P_2$ et de $D_2$ vers $P_1$ avec le consentement de tous et en suivant la procédure légale.

Plus généralement, un cycle d'échange d'organes associe $k$ paires de patient-donneur $(P_{i_1},D_{i_1}) ,\dots ,(P_{i_k}, D_{i_k})$ de sorte que $D_{i_l}$ donne à $P_{i_{l+1}}$ pour $l=1 , \dots , k−1$ et $D_{i_k}$ donne à $P_{i_1}$. 

Par ailleurs, le point essentiel est que les transferts soient tous réalisés en même temps et dans le même hôpital pour éviter qu'une rétractation de dernière minute ne lèse un patient et son donneur, et que les patients et donneurs venus ensemble et leur famille puissent se soutenir émotionnellement durant l'hospitalisation. Pour cette raison, le nombre d'échanges prenant place au sein d'un même cycle est nécessairement limité. En pratique, l'organisation d'un cycle de trois paires est déjà une épreuve pour le personnel d'un hôpital, et le plus grand cycle ayant jamais eu lieu a a impliqué six patients et donneurs.

Dans ce projet, nous prendrons le point de vue de l'organisme national responsable de la gestion du programme d'échange d'organes. À chaque phase d'échange, l'objectif de cet organisme est de choisir un ensemble de cycles d'échanges entre paires compatibles afin de maximiser le nombre de patients recevant un organe. Dans certains cas, on peut aussi donner une priorité à certains patients en fonction de la gravité de leur état ou de la durée de leur attente. Pour cela, on pourra attribuer des poids différents à chaque patient et maximiser la somme des poids des patients recevant un organe.

## 2 - Données

Les données utilisées pour ce projet proviennent des jeux de données de la [PrefLib](https://preflib.github.io/PrefLib-Jekyll/dataset/00036). Ces jeux de données ne correspondent pas à des programmes d'échanges d'organes réels pour des raisons de confidentialité, mais ils reproduisent la structure des données réelles. Ils sont constitués d'informations individuelles et d'un graphe de compatibilité. 

## 3 - Approche Déterministe

Dans cette première approche, nous allons considérer connaître la compatibilité réelle entre deux individus. A cet effet, nous utiliserons les fichiers .wmd de la PrefLib, décrivant un graphe de compatibilité orienté, $G=(V , A)$ , où chaque sommet de $V$ représente une paire donneur-malade et où un arc entre deux paires $( P_k , D_k )$ et $( P_l , D_l )$ signifie que $D_k$ est compatible avec $P_l$. La compatibilité est obtenue à partir des données biologiques individuelles (e.g., les groupes sanguins) et d'un test croisé lors duquel des biologistes mettent en présence des tissus d'un malade et d'un donneur supposé.

L'objectif de cette partie est de développer des méthodes d'optimisation permettant de trouver les meilleurs cycles de dons possibles. Ici, "meilleurs" signifie que nous chercherons un ensemble de cycles maximisant le nombre total de transplantation total. 

Plusieurs méthodes de résolution seront proposées :
- *Programmes linéaires* en nombre entiers : 3 PLNE permettant de trouver les cycles optimaux dans 3 cas distincts (taille des cycles non contraint, taille des cycles $\le$ $k$, et tailles des cycles $=$ $2$).
- Un algorithme de *génération de colonne* : résolution itérative du problème évitant de dénombrer tous les cycles possibles (les détails de la méthode sont donnés dans le [notebook principal](https://github.com/mathlommel/Optimal_Kidney_Exchange/blob/main/Projet_OSI_THOMAS_LOMMEL.ipynb)).

Ces méthodes seront soumises à des tests, permettant de nous conforter quant à leur fonctionnement et de comparer leur efficacité. Une dernière partie sera dédiée à une partie *éthique*, dans laquelle nous remettons en question les modèles construits, et comparons de manière qualitative les cycles rendus, ainsi que la variabilité de ce résultat en fonction des choix en entrée.

## 4 - Approche avec Incertitudes

Dans la pratique, il est important de savoir que les tests croisés permettant de confirmer la compatibilité entre donneurs et malades peuvent être lourds à réaliser pour les malades et qu'ils demandent des ressources importantes auprès des services hospitaliers. Chaque test est précédé de consultations médicales pour le patient et le donneur au cours desquels des tissus sont prélevés, puis des manipulations biologiques doivent être réalisées pour étudier la compatibilité des tissus. En outre, le nombre de tests croisés à réaliser est d'ordre quadratique en fonction du nombre de sommets du graphe de compatibilité.

En pratique, le programme d'échange est donc organisé en deux phases. Lors d'une première phase de planification, l'organisme ne dispose que de données individuelles sur chaque donneur et chaque receveur pour déduire la compatibilité a priori entre donneurs et patients. Ces données sont principalement le groupe sanguin et le complexe majeur d’histocompatibilité, aussi appelé système HLA. Pour ce projet, nous nous contenterons toutefois de prendre en compte le groupe sanguin. Il est par ailleurs possible de prendre en compte une probabilité d'échec du test croisé à partir d'autres données individuelles agrégées sous l'indicateur du pourcentage d'anti-corps réactifs (PRA) du malade de chaque paire.

Les opérations de transfert d'organe ne sont jamais planifiées avant d'avoir confirmé la compatibilité entre le donneur et le malade par un test croisé. Suite à la première phase, l'organisme responsable du programme d'échange planifie donc un ensemble de tests croisés pour vérifier la compatibilité entre certains malades et donneurs. Sachant la lourdeur des tests croisés, leur nombre est limité en pratique. On pourra pour cela considérer une limite fixe dépendant du nombre de paires patient-donneur ou bien supposer que les tests ne servent qu'à confirmer la compatibilité après avoir décidé les cycles d'échange entre patients a priori compatibles. La seconde phase du programme d'échange consiste à planifier les cycles de transferts d'organes une fois les résultats des tests croisés connus.

Du point de vue de l'aide à la décision, la première phase de l'organisation des transferts est un problème d'optimisation sous incertitudes. On souhaite décider l'ensemble des tests croisés à effectuer pour maximiser le nombres de dons d'organe alors qu'une partie des données est incertaine. Les données individuelles de groupes sanguins et de PRA sont bien connues (on dit aussi qu'elles sont déterministes), mais la compatibilité entre donneurs et malades est incertaine (elle dépend du résultat d'un test croisé). Ici, nous sommes toutefois dans le cas où les données incertaines sont stochastiques puisque nous supposerons que l'on connaît leur distribution de probabilité.

La suite du projet consistera à coder plusieurs approches d'optimisation sous incertitudes pour résoudre ce nouveau problème, plus proche des conditions réelles d'organisation des programmes d'échange d'organes. En pratique, la taille des cycles est bien souvent de taille $\le$ $3$. Pour cette seconde partie du projet, nous allons donc coder : 
- Un programme linéaire pour les cycles de dons de taille $2$
- Un programme linéaire pour les cycles de dons de taille $3$

Chacune de ces formulation se basera sur un ensemble de scénarios de compatibilité possibles. Le détail de ces méthodes est lui aussi décrit dans le [notebook principal](https://github.com/mathlommel/Optimal_Kidney_Exchange/blob/main/Projet_OSI_THOMAS_LOMMEL.ipynb).

Tout comme la partie déterministe, cette seconde partie sera aussi sujette à des tests : vérification des propriétés théoriques, comparaison des performances, comparaison avec le cas déterministe, et analyse des choix de modélisation.

## 5 - Structure du code
- RENDU N°1 : PARTIE DETERMINISTE

Le code principal est placé dans le notebook intitulé "Projet_OSI_THOMAS_LOMMEL". Dans celui-ci, se trouve le squelette du notebook initial du projet, complété par les codes et les explications nécessaires.

Toutes les parties du projet sont ensuite segmentées : 
- Pour la partie déterministe : "Formulations_compactes", "Generation_de_colonnes" et "Tests"
- Pour la partie avec incertitudes : "Formulations_avec_incertitudes"
Les codes et fonctions construites dans ces notebooks sont importées dans le notebook principal, au moment opportun.

Les instances de tests sont elles placées dans le dossier "Data_KEP". Aussi, pour faciliter l'explication, certaines images sont présentes, et affichées dans le notebook : celles-ci sont présentes dans le dossier "Images".

Toutes les sorties du notebook principal ont été gardées, et devraient normalement être visibles. Dans le  cas où ce ne serait pas le cas, une version .pdf est aussi présente. Attention toutefois : dans la version pdf, les images importées ne sont pas présentes, et certaines formules  LaTeX n'ont pas été affichées correctement.

## Contributors
Julie THOMAS & Mathias LOMMEL

---------------------------------------
Optimisation Sous Incertitudes

Département __Mathématiques Appliquées__

INSA Rennes, 2024-2025

