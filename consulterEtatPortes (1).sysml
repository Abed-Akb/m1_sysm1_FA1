package ConsulterEtatPortes {
    private import ScalarValues::*;

    /* ===================================================================
       Éléments de base (à supprimer si déjà définis dans votre modèle)
       =================================================================== */
    part def TechnicienMaintenance;
    part def ATMDPreviAccess;
    part def PorteAutomatique;

    // Informations échangées
    item def DemandeEtatPortes;
    item def InterrogationPorte;
    item def Mesures;
    item def AlerteMaintenance;
    item def EtatPortes;
    item def EtatHorsLigne;

    /* ===================================================================
       1. VUE DES FLUX D'ACTIONS : consulterEtatPortes

       Clés de lecture :
       Le flux démarre à la demande du technicien. L'ATMD interroge les
       portes. Un premier losange teste si elles sont joignables : si oui,
       on collecte et on évalue les mesures, sinon la porte est marquée
       "hors ligne". Un second losange teste la présence d'une anomalie,
       qui déclenche une alerte de maintenance. Les trois chemins
       convergent vers "consolider", puis "afficherEtatPortes" termine
       le flux.
       =================================================================== */
    action def ConsulterEtatPortes {
        in  attribute demandeConsultation : Boolean;
        out attribute etatPortes;

        attribute portesJoignables : Boolean;
        attribute anomalieDetectee : Boolean;

        action recevoirDemande;
        action interrogerPortes;
        action collecterMesures;
        action marquerHorsLigne;
        action evaluerEtat;
        action genererAlerteMaintenance;
        action consolider;
        action afficherEtatPortes;

        first start;
        then recevoirDemande;
        then interrogerPortes;
        then decide joignabilite;
            if portesJoignables then collecterMesures;
            else marquerHorsLigne;

        first collecterMesures then evaluerEtat;
        first evaluerEtat then decide anomalie;
            if anomalieDetectee then genererAlerteMaintenance;
            else consolider;

        first genererAlerteMaintenance then consolider;
        first marquerHorsLigne then consolider;

        first consolider then afficherEtatPortes;
        then done;
    }

    /* ===================================================================
       2. VUES DE SÉQUENCE (un scénario par cheminement du flux)

       Clés de lecture :
       Chaque "message" est un échange entre deux lignes de vie
       (technicien, atmd, porte). "first ... then ..." fixe l'ordre
       temporel. Scénario 1 : l'ATMD interroge la porte, reçoit les
       mesures (transmetMesures) et renvoie l'état au technicien.
       Scénario 2 : une alerte (transmetAlertes) est envoyée avant
       l'affichage de l'état. Scénario 3 : l'absence de réponse de la
       porte (timeout) fait afficher l'état "hors ligne".
       =================================================================== */

    // --- Scénario 1 : nominal, aucune anomalie ---
    part def Scenario_Nominal {
        part technicien : TechnicienMaintenance;
        part atmd       : ATMDPreviAccess;
        part porte      : PorteAutomatique;

        message m1 of DemandeEtatPortes  from technicien to atmd;
        message m2 of InterrogationPorte from atmd to porte;
        message m3 of Mesures            from porte to atmd;
        message m4 of EtatPortes         from atmd to technicien;

        first m1 then m2;
        first m2 then m3;
        first m3 then m4;
    }

    // --- Scénario 2 : anomalie détectée ---
    part def Scenario_Anomalie {
        part technicien : TechnicienMaintenance;
        part atmd       : ATMDPreviAccess;
        part porte      : PorteAutomatique;

        message m1 of DemandeEtatPortes  from technicien to atmd;
        message m2 of InterrogationPorte from atmd to porte;
        message m3 of Mesures            from porte to atmd;
        message m4 of AlerteMaintenance  from atmd to technicien;
        message m5 of EtatPortes         from atmd to technicien;

        first m1 then m2;
        first m2 then m3;
        first m3 then m4;
        first m4 then m5;
    }

    // --- Scénario 3 : porte hors ligne ---
    part def Scenario_HorsLigne {
        part technicien : TechnicienMaintenance;
        part atmd       : ATMDPreviAccess;
        part porte      : PorteAutomatique;

        message m1 of DemandeEtatPortes  from technicien to atmd;
        message m2 of InterrogationPorte from atmd to porte;
        // pas de réponse de la porte : délai dépassé (timeout)
        message m3 of EtatHorsLigne      from atmd to technicien;

        first m1 then m2;
        first m2 then m3;
    }
}
