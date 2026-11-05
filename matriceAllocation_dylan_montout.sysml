package ATMD_MatriceAllocation {

    doc /* Seance 3 - Matrice d'allocation (groupe ATMD PreviAccess).
     * "Affectation des blocs fonctionnels sur les blocs materiels
     *  a l'aide de la matrice d'allocation" (cadrage du mini-projet).
     *
     * Colonnes = blocs fonctionnels, issus des vues des sequences de chacun.
     * Lignes   = composants de la vue generale hierarchique des composants
     *            du groupe (VueGeneraleSysteme), noms repris a l'identique.
     */

    // =========================================================
    // 1. BLOCS FONCTIONNELS (colonnes de la matrice)
    //    Un seul nom par bloc : les doublons des sequences sont regroupes.
    // =========================================================

    part def LectureNFC           { doc /* Lire le badge du smartphone. Sources : LecteurNFC (Abed, Thanina). */ }
    part def ControleAcces        { doc /* Decider d'ouvrir ou de refuser. Sources : ControleurLocal (Abed), ControleurATMD (Thanina). */ }
    part def GestionDroits        { doc /* Garder et verifier les droits. Sources : BaseAutorisations (Abed), SystemeAutorisations (Thanina). */ }
    part def AcquisitionMesures   { doc /* Mesurer l'etat de la porte. Source : CapteursPorte (Abed). */ }
    part def AnalysePredictive    { doc /* Detecter les derives et alerter. Source : ModuleAnalyse (Abed). */ }
    part def Supervision          { doc /* Afficher alertes et etats. Sources : InterfaceSupervision (Abed), supervision (Dylan). */ }
    part def GestionUrgence       { doc /* Reagir au signal SSI. Source : gestionUrgence (Dylan). */ }
    part def PilotagePortes       { doc /* Commander verrou et ouverture. Source : pilotagePortes (Dylan). */ }
    part def Journalisation       { doc /* Enregistrer les evenements. Source : journalisation (Dylan). */ }

    part atmdFonctionnel {
        part lectureNFC         : LectureNFC;
        part controleAcces      : ControleAcces;
        part gestionDroits      : GestionDroits;
        part acquisitionMesures : AcquisitionMesures;
        part analysePredictive  : AnalysePredictive;
        part supervision        : Supervision;
        part gestionUrgence     : GestionUrgence;
        part pilotagePortes     : PilotagePortes;
        part journalisation     : Journalisation;
    }

    // =========================================================
    // 2. BLOCS MATERIELS (lignes de la matrice)
    //    Repris de la vue generale hierarchique des composants du groupe.
    // =========================================================

    part def ATMD_PreviAccess;
    part def SurveillanceMaintenance;
    part def CommandeAcces;
    part def IdentificationNFC;
    part def TraitementAcces;
    part def GestionAutorisations;
    part def CapteursPorte;
    part def ModuleAnalyse;
    part def InterfaceSupervision;
    part def PorteAutomatique;
    part def SmartphoneNFC;
    part def LecteurNFC;
    part def ControleurLocal;
    part def BaseAutorisations;

    part systeme : ATMD_PreviAccess {
        part surveillance : SurveillanceMaintenance {
            part capteurs    : CapteursPorte;
            part analyse     : ModuleAnalyse;
            part supervision : InterfaceSupervision;
        }
        part commande : CommandeAcces {
            part porte : PorteAutomatique;
        }
        part identification : IdentificationNFC {
            part smartphone : SmartphoneNFC;
            part lecteur    : LecteurNFC;
        }
        part traitement : TraitementAcces {
            part controleur : ControleurLocal;
        }
        part autorisations : GestionAutorisations {
            part base : BaseAutorisations;
        }
    }

    // =========================================================
    // 3. MATRICE D'ALLOCATION : une ligne = une croix du tableau
    //    allocate <bloc fonctionnel> to <bloc materiel>;
    // =========================================================

    allocate atmdFonctionnel.lectureNFC         to systeme.identification.lecteur;
    allocate atmdFonctionnel.controleAcces      to systeme.traitement.controleur;
    allocate atmdFonctionnel.gestionDroits      to systeme.autorisations.base;
    allocate atmdFonctionnel.acquisitionMesures to systeme.surveillance.capteurs;
    allocate atmdFonctionnel.analysePredictive  to systeme.surveillance.analyse;
    allocate atmdFonctionnel.supervision        to systeme.surveillance.supervision;
    allocate atmdFonctionnel.gestionUrgence     to systeme.traitement.controleur;
    allocate atmdFonctionnel.pilotagePortes     to systeme.commande.porte;
    allocate atmdFonctionnel.journalisation     to systeme.autorisations.base;
}
