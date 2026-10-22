package ATMD_Exigences {
    private import ScalarValues::*;
    private import ISQ::*;
    private import SI::*;
    private import ATMD_Contexte::*;
    private import ATMD_Contexte::parts::*;

    enum def Priorite {
        enum haute;
        enum moyenne;
        enum basse;
    }

    enum def MethodeVerification {
        enum test;
        enum analyse;
        enum inspection;
        enum demonstration;
    }

    requirement def ExigenceATMD {
        doc /* Exigence générique applicable au système ATMD PreviAccess. */
        subject atmd : ATMDPreviAccess;
        attribute priorite : Priorite;
        attribute verification : MethodeVerification;
        attribute casUtilisation : String;
    }

    requirement def ExigenceDelai :> ExigenceATMD {
        doc /* Le délai mesuré doit être inférieur ou égal au délai maximal. */
        attribute delaiMesure : DurationValue;
        attribute delaiMax : DurationValue;
        require constraint { delaiMesure <= delaiMax }
    }

    requirement def ExigenceDureeMin :> ExigenceATMD {
        doc /* La durée mesurée doit être supérieure ou égale à la durée minimale. */
        attribute dureeMesuree : DurationValue;
        attribute dureeMin : DurationValue;
        require constraint { dureeMesuree >= dureeMin }
    }

    requirement def ExigenceDistanceLecture :> ExigenceATMD {
        doc /* La distance de lecture doit être inférieure ou égale à la distance maximale. */
        attribute distanceLecture : LengthValue;
        attribute distanceMax : LengthValue;
        require constraint { distanceLecture <= distanceMax }
    }

    requirement def ExigenceDisponibilite :> ExigenceATMD {
        doc /* Le taux de disponibilité (en %) doit être supérieur ou égal au taux minimal. */
        attribute tauxDisponibilite : Real;
        attribute tauxMin : Real;
        require constraint { tauxDisponibilite >= tauxMin }
    }

    requirement def ExigenceCapacite :> ExigenceATMD {
        doc /* Le nombre d'utilisateurs gérés doit être supérieur ou égal au nombre minimal. */
        attribute nbUtilisateursGeres : Integer;
        attribute nbUtilisateursMin : Integer;
        require constraint { nbUtilisateursGeres >= nbUtilisateursMin }
    }

    requirement def ExigenceAlimentation :> ExigenceATMD {
        doc /* La tension d'alimentation doit rester dans la plage nominale ± tolérance. */
        attribute tension : ElectricPotentialDifferenceValue;
        attribute tensionNominale : ElectricPotentialDifferenceValue;
        attribute tolerance : Real;
        require constraint {
            tension >= tensionNominale * (1 - tolerance) and
            tension <= tensionNominale * (1 + tolerance)
        }
    }

    requirement def ExigenceTemperature :> ExigenceATMD {
        doc /* La température de fonctionnement doit rester entre la température minimale et la température maximale. */
        attribute temperature : CelsiusTemperatureValue;
        attribute temperatureMin : CelsiusTemperatureValue;
        attribute temperatureMax : CelsiusTemperatureValue;
        require constraint { temperature >= temperatureMin and temperature <= temperatureMax }
    }

    requirement <'EF-01'> lectureBadgeNFC : ExigenceATMD {
        doc /* Le système doit lire l'identifiant virtuel (badge) présenté
             * par le smartphone NFC d'un utilisateur. */
        attribute :>> priorite = Priorite::haute;
        attribute :>> verification = MethodeVerification::test;
        attribute :>> casUtilisation = "DemanderAccesNFC";
    }

    requirement <'EF-02'> controleAutorisation : ExigenceATMD {
        doc /* Le système doit vérifier que l'utilisateur possède un droit
             * valide pour la porte demandée (zone, plage horaire, date de validité)
             * et, si c'est le cas, commander l'ouverture de la porte automatique. */
        attribute :>> priorite = Priorite::haute;
        attribute :>> verification = MethodeVerification::test;
        attribute :>> casUtilisation = "DemanderAccesNFC";
    }

    requirement <'EF-03'> refusAcces : ExigenceATMD {
        doc /* En cas de droit absent, expiré ou révoqué, le système doit refuser
             * l'accès, maintenir la porte fermée et informer l'utilisateur
             * (retour visuel, sonore ou notification sur le smartphone). */
        attribute :>> priorite = Priorite::haute;
        attribute :>> verification = MethodeVerification::test;
        attribute :>> casUtilisation = "DemanderAccesNFC";
    }

    requirement <'EF-04'> gestionAutorisations : ExigenceATMD {
        doc /* Le système doit permettre au gestionnaire de créer, modifier,
             * suspendre et révoquer les droits d'accès des utilisateurs
             * (par personne, groupe, porte et plage horaire). */
        attribute :>> priorite = Priorite::haute;
        attribute :>> verification = MethodeVerification::demonstration;
        attribute :>> casUtilisation = "GererAutorisations";
    }

    requirement <'EF-05'> synchronisationDroits : ExigenceATMD {
        doc /* Le système doit synchroniser les droits d'accès, via le réseau
             * Internet, entre le serveur de gestion et les contrôleurs de porte. */
        attribute :>> priorite = Priorite::haute;
        attribute :>> verification = MethodeVerification::test;
        attribute :>> casUtilisation = "GererAutorisations";
    }

    requirement <'EF-06'> journalisation : ExigenceATMD {
        doc /* Le système doit horodater et enregistrer chaque événement
             * (accès accordé, accès refusé, ouverture forcée, porte restée ouverte,
             * alarme) avec l'identité de l'utilisateur et la porte concernée. */
        attribute :>> priorite = Priorite::haute;
        attribute :>> verification = MethodeVerification::test;
        attribute :>> casUtilisation = "ConsulterAcces";
    }

    requirement <'EF-07'> consultationEvenements : ExigenceATMD {
        doc /* Le système doit permettre à l'agent de sécurité de consulter
             * et de filtrer l'historique des accès (date, porte, utilisateur, type). */
        attribute :>> priorite = Priorite::moyenne;
        attribute :>> verification = MethodeVerification::demonstration;
        attribute :>> casUtilisation = "ConsulterAcces";
    }

    requirement <'EF-08'> surveillanceEtatPortes : ExigenceATMD {
        doc /* Le système doit recueillir les mesures transmises par chaque porte
             * (nombre de cycles, temps d'ouverture et de fermeture, courant moteur,
             * vibrations) et afficher l'état de chaque porte en temps réel. */
        attribute :>> priorite = Priorite::moyenne;
        attribute :>> verification = MethodeVerification::test;
        attribute :>> casUtilisation = "SurveillerEtatPortes";
    }

    requirement <'EF-09'> maintenancePredictive : ExigenceATMD {
        doc /* Le système doit détecter les dérives des mesures par rapport au
             * comportement nominal et émettre une alerte de maintenance
             * prédictive à destination du technicien avant la défaillance. */
        attribute :>> priorite = Priorite::haute;
        attribute :>> verification = MethodeVerification::analyse;
        attribute :>> casUtilisation = "ConsulterAlertes";
    }

    requirement <'EF-10'> consultationAlertes : ExigenceATMD {
        doc /* Le système doit permettre au technicien de consulter, d'acquitter
             * et de clôturer les alertes, avec l'historique des interventions. */
        attribute :>> priorite = Priorite::moyenne;
        attribute :>> verification = MethodeVerification::demonstration;
        attribute :>> casUtilisation = "ConsulterAlertes";
    }

    requirement <'EF-11'> situationUrgence : ExigenceATMD {
        doc /* À la réception d'un signal du système de sécurité incendie (SSI),
             * le système doit déverrouiller et ouvrir toutes les portes situées
             * sur les chemins d'évacuation, en priorité sur toute autre commande. */
        attribute :>> priorite = Priorite::haute;
        attribute :>> verification = MethodeVerification::test;
        attribute :>> casUtilisation = "GererSituationUrgence";
    }

    requirement <'EP-01'> tempsReponseAcces : ExigenceDelai {
        doc /* Le délai entre la présentation du smartphone et la commande
             * d'ouverture doit être de 1 s au plus. */
        attribute :>> delaiMax = 1 [s];
        attribute :>> priorite = Priorite::haute;
        attribute :>> verification = MethodeVerification::test;
        attribute :>> casUtilisation = "DemanderAccesNFC";
    }

    requirement <'EP-02'> distanceLectureNFC : ExigenceDistanceLecture {
        doc /* La lecture NFC doit s'effectuer à une distance de 5 cm au plus,
             * afin d'éviter toute lecture involontaire ou à distance. */
        attribute :>> distanceMax = 5 [cm];
        attribute :>> priorite = Priorite::moyenne;
        attribute :>> verification = MethodeVerification::test;
        attribute :>> casUtilisation = "DemanderAccesNFC";
    }

    requirement <'EP-03'> delaiPropagationDroits : ExigenceDelai {
        doc /* Une modification ou une révocation de droit doit être effective sur
             * toutes les portes en 5 min au plus lorsque le réseau est disponible. */
        attribute :>> delaiMax = 5 [min];
        attribute :>> priorite = Priorite::haute;
        attribute :>> verification = MethodeVerification::test;
        attribute :>> casUtilisation = "GererAutorisations";
    }

    requirement <'EP-04'> delaiEmissionAlerte : ExigenceDelai {
        doc /* Une alerte (panne ou dérive détectée) doit être transmise au
             * technicien en 1 min au plus après sa détection. */
        attribute :>> delaiMax = 1 [min];
        attribute :>> priorite = Priorite::moyenne;
        attribute :>> verification = MethodeVerification::test;
        attribute :>> casUtilisation = "ConsulterAlertes";
    }

    requirement <'EP-05'> anticipationPanne : ExigenceDureeMin {
        doc /* L'alerte prédictive doit être émise au moins 7 jours avant la
             * défaillance estimée de la porte. */
        attribute :>> dureeMin = 7 [d];
        attribute :>> priorite = Priorite::moyenne;
        attribute :>> verification = MethodeVerification::analyse;
        attribute :>> casUtilisation = "ConsulterAlertes";
    }

    requirement <'EP-06'> delaiOuvertureUrgence : ExigenceDelai {
        doc /* Les portes doivent être déverrouillées en 1 s au plus après la
             * réception du signal du SSI. */
        attribute :>> delaiMax = 1 [s];
        attribute :>> priorite = Priorite::haute;
        attribute :>> verification = MethodeVerification::test;
        attribute :>> casUtilisation = "GererSituationUrgence";
    }

    requirement <'EP-07'> capaciteUtilisateurs : ExigenceCapacite {
        doc /* Le système doit gérer au moins 5 000 utilisateurs. */
        attribute :>> nbUtilisateursMin = 5000;
        attribute :>> priorite = Priorite::basse;
        attribute :>> verification = MethodeVerification::analyse;
        attribute :>> casUtilisation = "GererAutorisations";
    }

    requirement <'ED-01'> fonctionnementHorsLigne : ExigenceDureeMin {
        doc /* En cas de perte du réseau Internet, le système doit continuer à
             * contrôler les accès à partir des droits en cache local pendant
             * au moins 72 h, puis resynchroniser le journal au retour du réseau. */
        attribute :>> dureeMin = 72 [h];
        attribute :>> priorite = Priorite::haute;
        attribute :>> verification = MethodeVerification::test;
        attribute :>> casUtilisation = "DemanderAccesNFC";
    }

    requirement <'ED-02'> autonomieBatterie : ExigenceDureeMin {
        doc /* En cas de coupure du réseau électrique, le système doit rester
             * opérationnel sur batterie pendant au moins 1 h. */
        attribute :>> dureeMin = 1 [h];
        attribute :>> priorite = Priorite::haute;
        attribute :>> verification = MethodeVerification::test;
        attribute :>> casUtilisation = "DemanderAccesNFC";
    }

    requirement <'ED-03'> disponibilite : ExigenceDisponibilite {
        doc /* La disponibilité annuelle du contrôle d'accès doit être d'au moins 99,5 %. */
        attribute :>> tauxMin = 99.5;
        attribute :>> priorite = Priorite::moyenne;
        attribute :>> verification = MethodeVerification::analyse;
        attribute :>> casUtilisation = "DemanderAccesNFC";
    }

    requirement <'ES-01'> securiteEvacuation : ExigenceATMD {
        doc /* Sur une issue de secours, une défaillance du système ou une perte
             * totale d'énergie ne doit jamais empêcher la sortie des personnes
             * (déverrouillage en sécurité positive). */
        attribute :>> priorite = Priorite::haute;
        attribute :>> verification = MethodeVerification::test;
        attribute :>> casUtilisation = "GererSituationUrgence";
    }

    requirement <'ES-02'> securiteEchangesNFC : ExigenceATMD {
        doc /* Les échanges entre le smartphone et le lecteur doivent être chiffrés,
             * authentifiés mutuellement et protégés contre le rejeu et le clonage. */
        attribute :>> priorite = Priorite::haute;
        attribute :>> verification = MethodeVerification::analyse;
        attribute :>> casUtilisation = "DemanderAccesNFC";
    }

    requirement <'ES-03'> controleRoles : ExigenceATMD {
        doc /* L'accès aux fonctions de gestion, de consultation et de maintenance
             * doit être authentifié et limité selon le rôle (gestionnaire,
             * agent de sécurité, technicien). */
        attribute :>> priorite = Priorite::haute;
        attribute :>> verification = MethodeVerification::test;
        attribute :>> casUtilisation = "GererAutorisations";
    }

    requirement <'ES-04'> detectionIntrusion : ExigenceATMD {
        doc /* Le système doit signaler à l'agent de sécurité toute ouverture
             * forcée et toute porte maintenue ouverte au-delà d'un délai paramétrable. */
        attribute :>> priorite = Priorite::moyenne;
        attribute :>> verification = MethodeVerification::test;
        attribute :>> casUtilisation = "SurveillerEtatPortes";
    }

    requirement <'ES-05'> conformiteRGPD : ExigenceATMD {
        doc /* Les données personnelles et le journal des accès doivent être
             * traités conformément au RGPD (finalité, minimisation, durée de
             * conservation limitée, droits d'accès et d'effacement). */
        attribute :>> priorite = Priorite::haute;
        attribute :>> verification = MethodeVerification::inspection;
        attribute :>> casUtilisation = "ConsulterAcces";
    }

    requirement <'EI-01'> alimentationSecteur : ExigenceAlimentation {
        doc /* Le système doit être alimenté par le réseau électrique 230 V AC ± 10 %. */
        attribute :>> tensionNominale = 230 [V];
        attribute :>> tolerance = 0.10;
        attribute :>> priorite = Priorite::haute;
        attribute :>> verification = MethodeVerification::test;
        attribute :>> casUtilisation = "DemanderAccesNFC";
    }

    requirement <'EI-02'> compatibiliteSmartphones : ExigenceATMD {
        doc /* Le système doit être compatible avec les smartphones Android et iOS
             * équipés du NFC (norme ISO/IEC 14443). */
        attribute :>> priorite = Priorite::haute;
        attribute :>> verification = MethodeVerification::test;
        attribute :>> casUtilisation = "DemanderAccesNFC";
    }

    requirement <'EI-03'> interfaceSSI : ExigenceATMD {
        doc /* Le système doit disposer d'une entrée dédiée et surveillée pour
             * recevoir le signal d'urgence du système de sécurité incendie. */
        attribute :>> priorite = Priorite::haute;
        attribute :>> verification = MethodeVerification::inspection;
        attribute :>> casUtilisation = "GererSituationUrgence";
    }

    requirement <'EI-04'> interfacePortes : ExigenceATMD {
        doc /* Le système doit commander les portes automatiques et recevoir leurs
             * mesures d'état via une interface normalisée (par exemple Modbus sur RS-485). */
        attribute :>> priorite = Priorite::moyenne;
        attribute :>> verification = MethodeVerification::test;
        attribute :>> casUtilisation = "SurveillerEtatPortes";
    }

    requirement <'EE-01'> temperatureFonctionnement : ExigenceTemperature {
        doc /* Les lecteurs NFC doivent fonctionner entre -20 °C et +50 °C. */
        attribute :>> temperatureMin = -20 ['°C'];
        attribute :>> temperatureMax = 50 ['°C'];
        attribute :>> priorite = Priorite::moyenne;
        attribute :>> verification = MethodeVerification::test;
        attribute :>> casUtilisation = "DemanderAccesNFC";
    }

    requirement <'EE-02'> protectionLecteurs : ExigenceATMD {
        doc /* Les lecteurs installés en extérieur doivent avoir un indice de
             * protection IP65 au minimum et une résistance au vandalisme IK08 au minimum. */
        attribute :>> priorite = Priorite::basse;
        attribute :>> verification = MethodeVerification::inspection;
        attribute :>> casUtilisation = "DemanderAccesNFC";
    }

    satisfy lectureBadgeNFC by contexte.atmd;
    satisfy controleAutorisation by contexte.atmd;
    satisfy refusAcces by contexte.atmd;
    satisfy gestionAutorisations by contexte.atmd;
    satisfy synchronisationDroits by contexte.atmd;
    satisfy journalisation by contexte.atmd;
    satisfy consultationEvenements by contexte.atmd;
    satisfy surveillanceEtatPortes by contexte.atmd;
    satisfy maintenancePredictive by contexte.atmd;
    satisfy consultationAlertes by contexte.atmd;
    satisfy situationUrgence by contexte.atmd;
    satisfy tempsReponseAcces by contexte.atmd;
    satisfy distanceLectureNFC by contexte.atmd;
    satisfy delaiPropagationDroits by contexte.atmd;
    satisfy delaiEmissionAlerte by contexte.atmd;
    satisfy anticipationPanne by contexte.atmd;
    satisfy delaiOuvertureUrgence by contexte.atmd;
    satisfy capaciteUtilisateurs by contexte.atmd;
    satisfy fonctionnementHorsLigne by contexte.atmd;
    satisfy autonomieBatterie by contexte.atmd;
    satisfy disponibilite by contexte.atmd;
    satisfy securiteEvacuation by contexte.atmd;
    satisfy securiteEchangesNFC by contexte.atmd;
    satisfy controleRoles by contexte.atmd;
    satisfy detectionIntrusion by contexte.atmd;
    satisfy conformiteRGPD by contexte.atmd;
    satisfy alimentationSecteur by contexte.atmd;
    satisfy compatibiliteSmartphones by contexte.atmd;
    satisfy interfaceSSI by contexte.atmd;
    satisfy interfacePortes by contexte.atmd;
    satisfy temperatureFonctionnement by contexte.atmd;
    satisfy protectionLecteurs by contexte.atmd;

    dependency from refusAcces to controleAutorisation;
    dependency from consultationEvenements to journalisation;
    dependency from consultationAlertes to maintenancePredictive;
    dependency from tempsReponseAcces to controleAutorisation;
    dependency from distanceLectureNFC to lectureBadgeNFC;
    dependency from delaiPropagationDroits to synchronisationDroits;
    dependency from delaiEmissionAlerte to maintenancePredictive;
    dependency from anticipationPanne to maintenancePredictive;
    dependency from delaiOuvertureUrgence to situationUrgence;
    dependency from capaciteUtilisateurs to gestionAutorisations;
    dependency from fonctionnementHorsLigne to synchronisationDroits;
    dependency from securiteEvacuation to situationUrgence;
    dependency from securiteEchangesNFC to lectureBadgeNFC;
    dependency from controleRoles to gestionAutorisations;
    dependency from detectionIntrusion to surveillanceEtatPortes;
    dependency from conformiteRGPD to journalisation;
    dependency from compatibiliteSmartphones to lectureBadgeNFC;
    dependency from interfaceSSI to situationUrgence;
    dependency from interfacePortes to surveillanceEtatPortes;
    dependency from temperatureFonctionnement to lectureBadgeNFC;
    dependency from protectionLecteurs to lectureBadgeNFC;

    dependency from lectureBadgeNFC to Contexte::smartphone;
    dependency from refusAcces to Contexte::utilisateur;
    dependency from controleAutorisation to Contexte::porte;
    dependency from gestionAutorisations to Contexte::gestionnaire;
    dependency from synchronisationDroits to Contexte::internet;
    dependency from consultationEvenements to Contexte::agentSecurite;
    dependency from detectionIntrusion to Contexte::agentSecurite;
    dependency from surveillanceEtatPortes to Contexte::porte;
    dependency from consultationAlertes to Contexte::technicien;
    dependency from situationUrgence to Contexte::securiteIncendie;
    dependency from autonomieBatterie to Contexte::alimentation;
    dependency from alimentationSecteur to Contexte::alimentation;
}