package ATMD_Verification {
    private import ATMD_Exigences::*;
    private import ATMD_Contexte::*;

    /* ===================================================================
       VÉRIFICATIONS SUR LES EXIGENCES (séance 3)

       Clés de lecture :
       Chaque exigence du package ATMD_Exigences est associée à un cas de
       vérification ("verification def") dont l'objectif ("verify") pointe
       vers l'exigence. La documentation de chaque cas donne la méthode
       (test, analyse, inspection, démonstration, identique à l'attribut
       "verification" de l'exigence), la procédure et le critère de
       réussite. Les exigences sont aussi satisfaites par des blocs via
       les "satisfy" du fichier des exigences. La matrice de couverture
       ci-dessous résume l'ensemble : 32 exigences, 32 cas de vérification.

       Répartition des méthodes : 21 tests, 5 analyses, 3 démonstrations,
       3 inspections.

       MATRICE DE COUVERTURE
       (la colonne "Bloc candidat" est une HYPOTHÈSE à aligner avec votre
        décomposition matérielle et votre matrice d'allocation)

       ID     | Exigence                | Méthode       | Cas de vérification  | Bloc candidat
       -------+-------------------------+---------------+----------------------+------------------------
       EF-01  | lectureBadgeNFC         | test          | VC_EF01              | Lecteur NFC
       EF-02  | controleAutorisation    | test          | VC_EF02              | Contrôleur de porte
       EF-03  | refusAcces              | test          | VC_EF03              | Contrôleur de porte
       EF-04  | gestionAutorisations    | démonstration | VC_EF04              | Serveur de gestion
       EF-05  | synchronisationDroits   | test          | VC_EF05              | Serveur de gestion
       EF-06  | journalisation          | test          | VC_EF06              | Serveur de gestion
       EF-07  | consultationEvenements  | démonstration | VC_EF07              | Serveur de gestion
       EF-08  | surveillanceEtatPortes  | test          | VC_EF08              | Contrôleur de porte
       EF-09  | maintenancePredictive   | analyse       | VC_EF09              | Module de maintenance
       EF-10  | consultationAlertes     | démonstration | VC_EF10              | Module de maintenance
       EF-11  | situationUrgence        | test          | VC_EF11              | Contrôleur de porte
       EP-01  | tempsReponseAcces       | test          | VC_EP01              | Lecteur NFC + contrôleur
       EP-02  | distanceLectureNFC      | test          | VC_EP02              | Lecteur NFC
       EP-03  | delaiPropagationDroits  | test          | VC_EP03              | Serveur + passerelle
       EP-04  | delaiEmissionAlerte     | test          | VC_EP04              | Module de maintenance
       EP-05  | anticipationPanne       | analyse       | VC_EP05              | Module de maintenance
       EP-06  | delaiOuvertureUrgence   | test          | VC_EP06              | Contrôleur de porte
       EP-07  | capaciteUtilisateurs    | analyse       | VC_EP07              | Serveur de gestion
       ED-01  | fonctionnementHorsLigne | test          | VC_ED01              | Contrôleur de porte
       ED-02  | autonomieBatterie       | test          | VC_ED02              | Alimentation secourue
       ED-03  | disponibilite           | analyse       | VC_ED03              | Ensemble du système
       ES-01  | securiteEvacuation      | test          | VC_ES01              | Contrôleur de porte
       ES-02  | securiteEchangesNFC     | analyse       | VC_ES02              | Lecteur NFC
       ES-03  | controleRoles           | test          | VC_ES03              | Serveur de gestion
       ES-04  | detectionIntrusion      | test          | VC_ES04              | Contrôleur de porte
       ES-05  | conformiteRGPD          | inspection    | VC_ES05              | Serveur de gestion
       EI-01  | alimentationSecteur     | test          | VC_EI01              | Alimentation secourue
       EI-02  | compatibiliteSmartphones| test          | VC_EI02              | Lecteur NFC
       EI-03  | interfaceSSI            | inspection    | VC_EI03              | Interface SSI
       EI-04  | interfacePortes         | test          | VC_EI04              | Contrôleur de porte
       EE-01  | temperatureFonctionnement| test         | VC_EE01              | Lecteur NFC
       EE-02  | protectionLecteurs      | inspection    | VC_EE02              | Lecteur NFC
       =================================================================== */

    // ------------------------------------------------------------------
    // Exigences fonctionnelles
    // ------------------------------------------------------------------
    verification def VC_EF01 {
        doc /* Méthode : test.
             * Procédure : présenter 50 fois un smartphone Android puis 50 fois
             * un smartphone iOS enregistrés devant le lecteur NFC.
             * Critère : l'identifiant virtuel est lu et transmis à l'ATMD
             * à chaque présentation. */
        objective { verify lectureBadgeNFC; }
    }

    verification def VC_EF02 {
        doc /* Méthode : test.
             * Procédure : présenter un badge avec droit valide, puis invalider
             * tour à tour la zone, la plage horaire et la date de validité.
             * Critère : la commande d'ouverture n'est émise que si les trois
             * conditions sont réunies. */
        objective { verify controleAutorisation; }
    }

    verification def VC_EF03 {
        doc /* Méthode : test.
             * Procédure : présenter un badge dont le droit est absent, expiré
             * puis révoqué.
             * Critère : la porte reste fermée et l'utilisateur est informé
             * (retour visuel, sonore ou notification). */
        objective { verify refusAcces; }
    }

    verification def VC_EF04 {
        doc /* Méthode : démonstration.
             * Procédure : le gestionnaire crée, modifie, suspend puis révoque
             * un droit, par personne, par groupe, par porte et par plage
             * horaire.
             * Critère : chaque opération est acceptée et visible dans
             * l'interface de gestion. */
        objective { verify gestionAutorisations; }
    }

    verification def VC_EF05 {
        doc /* Méthode : test.
             * Procédure : modifier un droit sur le serveur de gestion puis
             * comparer les droits stockés sur chaque contrôleur de porte.
             * Critère : les droits sont identiques sur le serveur et sur tous
             * les contrôleurs. */
        objective { verify synchronisationDroits; }
    }

    verification def VC_EF06 {
        doc /* Méthode : test.
             * Procédure : générer chaque type d'événement (accès accordé,
             * refusé, ouverture forcée, porte restée ouverte, alarme).
             * Critère : chaque événement est enregistré avec horodatage,
             * identité de l'utilisateur et porte concernée. */
        objective { verify journalisation; }
    }

    verification def VC_EF07 {
        doc /* Méthode : démonstration.
             * Procédure : l'agent de sécurité consulte l'historique et le
             * filtre par date, porte, utilisateur et type d'événement.
             * Critère : les résultats affichés correspondent aux filtres. */
        objective { verify consultationEvenements; }
    }

    verification def VC_EF08 {
        doc /* Méthode : test.
             * Procédure : simuler sur un banc de porte les mesures (cycles,
             * temps d'ouverture et de fermeture, courant moteur, vibrations)
             * et faire varier l'état de la porte.
             * Critère : l'ATMD reçoit toutes les mesures et l'état affiché au
             * technicien suit l'état réel de chaque porte. */
        objective { verify surveillanceEtatPortes; }
    }

    verification def VC_EF09 {
        doc /* Méthode : analyse.
             * Procédure : rejouer sur le modèle de détection des jeux de
             * mesures simulant une dérive progressive.
             * Critère : une alerte prédictive est émise avant la défaillance
             * simulée. */
        objective { verify maintenancePredictive; }
    }

    verification def VC_EF10 {
        doc /* Méthode : démonstration.
             * Procédure : le technicien consulte une alerte, l'acquitte puis
             * la clôture, et consulte l'historique des interventions.
             * Critère : chaque état de l'alerte est tracé dans l'historique. */
        objective { verify consultationAlertes; }
    }

    verification def VC_EF11 {
        doc /* Méthode : test.
             * Procédure : injecter un signal du SSI pendant qu'une commande
             * d'accès normale est en cours.
             * Critère : toutes les portes des chemins d'évacuation sont
             * déverrouillées et ouvertes, en priorité sur l'autre commande. */
        objective { verify situationUrgence; }
    }

    // ------------------------------------------------------------------
    // Exigences de performance
    // ------------------------------------------------------------------
    verification def VC_EP01 {
        doc /* Méthode : test.
             * Procédure : chronométrer 100 accès entre la présentation du
             * smartphone et la commande d'ouverture.
             * Critère : délai mesuré <= 1 s pour chaque mesure. */
        objective { verify tempsReponseAcces; }
    }

    verification def VC_EP02 {
        doc /* Méthode : test.
             * Procédure : approcher le smartphone du lecteur par pas de 1 cm.
             * Critère : lecture à 5 cm ou moins, aucune lecture au-delà. */
        objective { verify distanceLectureNFC; }
    }

    verification def VC_EP03 {
        doc /* Méthode : test.
             * Procédure : révoquer un droit sur le serveur et mesurer le
             * temps jusqu'au refus effectif sur chaque porte, réseau
             * disponible.
             * Critère : délai mesuré <= 5 min sur toutes les portes. */
        objective { verify delaiPropagationDroits; }
    }

    verification def VC_EP04 {
        doc /* Méthode : test.
             * Procédure : provoquer un défaut simulé et mesurer le temps
             * entre sa détection et la réception de l'alerte par le
             * technicien.
             * Critère : délai mesuré <= 1 min. */
        objective { verify delaiEmissionAlerte; }
    }

    verification def VC_EP05 {
        doc /* Méthode : analyse.
             * Procédure : appliquer le modèle prédictif à des historiques de
             * dégradation de portes jusqu'à la défaillance.
             * Critère : le préavis de l'alerte est >= 7 jours. */
        objective { verify anticipationPanne; }
    }

    verification def VC_EP06 {
        doc /* Méthode : test.
             * Procédure : injecter un signal du SSI et mesurer le temps
             * jusqu'au déverrouillage de chaque porte.
             * Critère : délai mesuré <= 1 s. */
        objective { verify delaiOuvertureUrgence; }
    }

    verification def VC_EP07 {
        doc /* Méthode : analyse.
             * Procédure : dimensionner la base de données et simuler une
             * charge de 5 000 utilisateurs (droits, journal).
             * Critère : le système gère au moins 5 000 utilisateurs sans
             * dégradation des délais EP-01 et EP-03. */
        objective { verify capaciteUtilisateurs; }
    }

    // ------------------------------------------------------------------
    // Exigences de disponibilité
    // ------------------------------------------------------------------
    verification def VC_ED01 {
        doc /* Méthode : test.
             * Procédure : couper la liaison Internet pendant 72 h puis la
             * rétablir.
             * Critère : les accès sont contrôlés avec les droits en cache
             * pendant 72 h, puis le journal est resynchronisé. */
        objective { verify fonctionnementHorsLigne; }
    }

    verification def VC_ED02 {
        doc /* Méthode : test.
             * Procédure : couper l'alimentation secteur et mesurer la durée de
             * fonctionnement sur batterie.
             * Critère : durée mesurée >= 1 h. */
        objective { verify autonomieBatterie; }
    }

    verification def VC_ED03 {
        doc /* Méthode : analyse.
             * Procédure : calculer la disponibilité annuelle à partir des
             * MTBF et MTTR des blocs.
             * Critère : disponibilité calculée >= 99,5 %. */
        objective { verify disponibilite; }
    }

    // ------------------------------------------------------------------
    // Exigences de sûreté et de sécurité
    // ------------------------------------------------------------------
    verification def VC_ES01 {
        doc /* Méthode : test.
             * Procédure : sur une issue de secours, simuler une défaillance du
             * système puis une perte totale d'énergie.
             * Critère : la porte est déverrouillée et la sortie reste
             * possible dans les deux cas. */
        objective { verify securiteEvacuation; }
    }

    verification def VC_ES02 {
        doc /* Méthode : analyse.
             * Procédure : revoir le protocole d'échange NFC (chiffrement,
             * authentification mutuelle) et rejouer des attaques par rejeu et
             * par clonage.
             * Critère : aucune attaque n'aboutit à une ouverture de porte. */
        objective { verify securiteEchangesNFC; }
    }

    verification def VC_ES03 {
        doc /* Méthode : test.
             * Procédure : se connecter avec chaque rôle (gestionnaire, agent
             * de sécurité, technicien) et tenter d'accéder aux fonctions des
             * autres rôles, puis sans authentification.
             * Critère : tout accès hors rôle ou non authentifié est refusé. */
        objective { verify controleRoles; }
    }

    verification def VC_ES04 {
        doc /* Méthode : test.
             * Procédure : forcer l'ouverture d'une porte, puis la maintenir
             * ouverte au-delà du délai paramétré.
             * Critère : l'agent de sécurité reçoit un signalement pour
             * chaque cas. */
        objective { verify detectionIntrusion; }
    }

    verification def VC_ES05 {
        doc /* Méthode : inspection.
             * Procédure : revue documentaire du traitement des données
             * (finalité, minimisation, durée de conservation, droits d'accès
             * et d'effacement).
             * Critère : tous les points de conformité RGPD sont justifiés. */
        objective { verify conformiteRGPD; }
    }

    // ------------------------------------------------------------------
    // Exigences d'interface
    // ------------------------------------------------------------------
    verification def VC_EI01 {
        doc /* Méthode : test.
             * Procédure : alimenter le système à 207 V puis à 253 V
             * (230 V +/- 10 %).
             * Critère : fonctionnement nominal aux deux tensions. */
        objective { verify alimentationSecteur; }
    }

    verification def VC_EI02 {
        doc /* Méthode : test.
             * Procédure : tester un panel de smartphones Android et iOS
             * équipés du NFC (ISO/IEC 14443).
             * Critère : tous les smartphones du panel sont lus. */
        objective { verify compatibiliteSmartphones; }
    }

    verification def VC_EI03 {
        doc /* Méthode : inspection.
             * Procédure : vérifier la présence d'une entrée dédiée au signal
             * du SSI et sa surveillance (détection de coupure de ligne).
             * Critère : entrée dédiée présente, la coupure de ligne est
             * détectée. */
        objective { verify interfaceSSI; }
    }

    verification def VC_EI04 {
        doc /* Méthode : test.
             * Procédure : échanger des commandes et des mesures avec une porte
             * via l'interface normalisée (par exemple Modbus sur RS-485).
             * Critère : commandes exécutées et mesures reçues sans erreur de
             * trame. */
        objective { verify interfacePortes; }
    }

    // ------------------------------------------------------------------
    // Exigences d'environnement
    // ------------------------------------------------------------------
    verification def VC_EE01 {
        doc /* Méthode : test.
             * Procédure : placer un lecteur NFC en enceinte climatique à
             * -20 °C puis à +50 °C et effectuer des lectures.
             * Critère : lecture correcte aux deux températures. */
        objective { verify temperatureFonctionnement; }
    }

    verification def VC_EE02 {
        doc /* Méthode : inspection.
             * Procédure : contrôler les fiches techniques et certificats du
             * lecteur extérieur.
             * Critère : indice IP65 minimum et résistance IK08 minimum
             * attestés. */
        objective { verify protectionLecteurs; }
    }
}
