package ATMD_GererSituationUrgence {

    doc /* Seance 2 - travail individuel - cas d'utilisation gererSituationUrgence.
     * Vue des flux d'actions : ProcessusGererSituationUrgence.
     * Vues des sequences : ScenarioAlarmeIncendie (chemin 1)
     * et ScenarioDefautLigneSSI (chemin 2). */

    private import ScalarValues::*;
    private import ATMD_Contexte::*;
    private import ATMD_Contexte::parts::*;
    private import ATMD_Exigences::*;
    private import ATMD::useCases::gererSituationUrgence;

    // =========================================================
    // 1. BLOCS FONCTIONNELS (identifies grace aux vues de sequence)
    // =========================================================

    part def GestionUrgence {
        doc /* Surveille l'entree SSI, decide de la reaction et pilote les autres blocs. */
    }
    part def PilotagePortes {
        doc /* Commande le deverrouillage, l'ouverture et le retour normal des portes. */
    }
    part def Supervision {
        doc /* Affiche les alertes et l'etat des portes a l'agent de securite. */
    }
    part def Journalisation {
        doc /* Horodate et enregistre chaque evenement d'urgence. */
    }

    // Le systeme atmd du contexte, vu avec ses blocs fonctionnels d'urgence
    part atmdUrgence :> contexte.atmd {
        part gestionUrgence : GestionUrgence;
        part pilotagePortes : PilotagePortes;
        part supervision    : Supervision;
        part journalisation : Journalisation;
    }

    // =========================================================
    // 2. VUE DES FLUX D'ACTIONS (Action Flow View)
    // =========================================================

    action def ProcessusGererSituationUrgence {
        doc /* Deroulement du cas d'utilisation gererSituationUrgence. */
        attribute estAlarmeIncendie : Boolean;

        first start;
        then action surveillerEntreeSSI;
        then action recevoirSignalSSI;
        then decide typeSignal;
            if estAlarmeIncendie then deverrouillerIssuesSecours;
            else passerEnSecuritePositive;

        // Chemin 1 : alarme incendie recue
        action deverrouillerIssuesSecours;
        then action ouvrirPortesEvacuation;
        then fusion;

        // Chemin 2 : defaut de la ligne SSI (signal perdu)
        action passerEnSecuritePositive;
        then action signalerDefautAgentSecurite;
        then fusion;

        // Suite commune aux deux chemins
        merge fusion;
        then action journaliserDebutUrgence;
        then action afficherEtatPortes;
        then action attendreFinSignal;
        then action retablirModeNormal;
        then action journaliserFinUrgence;
        then done;
    }

    // =========================================================
    // 3. VUES DES SEQUENCES (Sequence View)
    // =========================================================

    // ---------- Chemin 1 : alarme incendie ----------
    occurrence def ScenarioAlarmeIncendie {
        doc /* Chemin estAlarmeIncendie = vrai du flux d'actions. */

        ref part securiteIncendie :> contexte.securiteIncendie {
            event occurrence envoiAlarme;
            event occurrence envoiFinAlarme;
        }
        ref part gestionUrgence :> atmdUrgence.gestionUrgence {
            event occurrence receptionAlarme;
            event occurrence envoiOrdreEvacuation;
            event occurrence receptionCompteRendu;
            event occurrence envoiJournalDebut;
            event occurrence envoiAlerte;
            event occurrence receptionFinAlarme;
            event occurrence envoiOrdreNormal;
            event occurrence envoiJournalFin;
        }
        ref part pilotagePortes :> atmdUrgence.pilotagePortes {
            event occurrence receptionOrdreEvacuation;
            event occurrence envoiCommandeOuverture;
            event occurrence receptionConfirmation;
            event occurrence envoiCompteRendu;
            event occurrence receptionOrdreNormal;
            event occurrence envoiCommandeNormal;
        }
        ref part porte :> contexte.porte {
            event occurrence receptionCommandeOuverture;
            event occurrence envoiConfirmation;
            event occurrence receptionCommandeNormal;
        }
        ref part journalisation :> atmdUrgence.journalisation {
            event occurrence receptionJournalDebut;
            event occurrence receptionJournalFin;
        }
        ref part supervision :> atmdUrgence.supervision {
            event occurrence receptionAlerte;
            event occurrence envoiAffichage;
        }
        ref part agentSecurite :> contexte.agentSecurite {
            event occurrence receptionAffichage;
        }

        message signalAlarmeIncendie
            from securiteIncendie.envoiAlarme to gestionUrgence.receptionAlarme;
        message ordreDeverrouillageEvacuation
            from gestionUrgence.envoiOrdreEvacuation to pilotagePortes.receptionOrdreEvacuation;
        message commandeDeverrouillageOuverture
            from pilotagePortes.envoiCommandeOuverture to porte.receptionCommandeOuverture;
        message confirmationOuverture
            from porte.envoiConfirmation to pilotagePortes.receptionConfirmation;
        message compteRenduPortesOuvertes
            from pilotagePortes.envoiCompteRendu to gestionUrgence.receptionCompteRendu;
        message enregistrerDebutUrgence
            from gestionUrgence.envoiJournalDebut to journalisation.receptionJournalDebut;
        message alerteEvacuation
            from gestionUrgence.envoiAlerte to supervision.receptionAlerte;
        message affichageEtatPortes
            from supervision.envoiAffichage to agentSecurite.receptionAffichage;
        message finAlarme
            from securiteIncendie.envoiFinAlarme to gestionUrgence.receptionFinAlarme;
        message ordreRetourModeNormal
            from gestionUrgence.envoiOrdreNormal to pilotagePortes.receptionOrdreNormal;
        message commandeModeNormal
            from pilotagePortes.envoiCommandeNormal to porte.receptionCommandeNormal;
        message enregistrerFinUrgence
            from gestionUrgence.envoiJournalFin to journalisation.receptionJournalFin;
    }

    // ---------- Chemin 2 : defaut de la ligne SSI ----------
    occurrence def ScenarioDefautLigneSSI {
        doc /* Chemin estAlarmeIncendie = faux du flux d'actions :
         * la ligne SSI est coupee, le systeme passe en securite positive. */

        ref part securiteIncendie :> contexte.securiteIncendie {
            event occurrence envoiDefaut;
            event occurrence envoiRetablissement;
        }
        ref part gestionUrgence :> atmdUrgence.gestionUrgence {
            event occurrence receptionDefaut;
            event occurrence envoiOrdreSecuritePositive;
            event occurrence receptionCompteRendu;
            event occurrence envoiJournalDebut;
            event occurrence envoiAlerte;
            event occurrence receptionRetablissement;
            event occurrence envoiOrdreNormal;
            event occurrence envoiJournalFin;
        }
        ref part pilotagePortes :> atmdUrgence.pilotagePortes {
            event occurrence receptionOrdreSecuritePositive;
            event occurrence envoiCommandeDeverrouillage;
            event occurrence receptionConfirmation;
            event occurrence envoiCompteRendu;
            event occurrence receptionOrdreNormal;
            event occurrence envoiCommandeNormal;
        }
        ref part porte :> contexte.porte {
            event occurrence receptionCommandeDeverrouillage;
            event occurrence envoiConfirmation;
            event occurrence receptionCommandeNormal;
        }
        ref part journalisation :> atmdUrgence.journalisation {
            event occurrence receptionJournalDebut;
            event occurrence receptionJournalFin;
        }
        ref part supervision :> atmdUrgence.supervision {
            event occurrence receptionAlerte;
            event occurrence envoiDemande;
        }
        ref part agentSecurite :> contexte.agentSecurite {
            event occurrence receptionDemande;
        }

        message defautLigneSSI
            from securiteIncendie.envoiDefaut to gestionUrgence.receptionDefaut;
        message ordreSecuritePositive
            from gestionUrgence.envoiOrdreSecuritePositive to pilotagePortes.receptionOrdreSecuritePositive;
        message commandeDeverrouillage
            from pilotagePortes.envoiCommandeDeverrouillage to porte.receptionCommandeDeverrouillage;
        message confirmationDeverrouillage
            from porte.envoiConfirmation to pilotagePortes.receptionConfirmation;
        message compteRenduPortesDeverrouillees
            from pilotagePortes.envoiCompteRendu to gestionUrgence.receptionCompteRendu;
        message enregistrerDefautSSI
            from gestionUrgence.envoiJournalDebut to journalisation.receptionJournalDebut;
        message alerteDefautLigneSSI
            from gestionUrgence.envoiAlerte to supervision.receptionAlerte;
        message demandeIntervention
            from supervision.envoiDemande to agentSecurite.receptionDemande;
        message retablissementLigne
            from securiteIncendie.envoiRetablissement to gestionUrgence.receptionRetablissement;
        message ordreRetourModeNormal
            from gestionUrgence.envoiOrdreNormal to pilotagePortes.receptionOrdreNormal;
        message commandeModeNormal
            from pilotagePortes.envoiCommandeNormal to porte.receptionCommandeNormal;
        message enregistrerFinDefaut
            from gestionUrgence.envoiJournalFin to journalisation.receptionJournalFin;
    }

    // =========================================================
    // 4. LIENS (meme style que ATMD_Exigences)
    // =========================================================

    // Les vues detaillent le cas d'utilisation
    dependency from ProcessusGererSituationUrgence to gererSituationUrgence;
    dependency from ScenarioAlarmeIncendie to ProcessusGererSituationUrgence;
    dependency from ScenarioDefautLigneSSI to ProcessusGererSituationUrgence;

    // Les exigences sont satisfaites par les blocs fonctionnels
    satisfy situationUrgence      by atmdUrgence.gestionUrgence;   // EF-11
    satisfy interfaceSSI          by atmdUrgence.gestionUrgence;   // EI-03
    satisfy delaiOuvertureUrgence by atmdUrgence.pilotagePortes;   // EP-06
    satisfy securiteEvacuation    by atmdUrgence.pilotagePortes;   // ES-01
    satisfy journalisation        by atmdUrgence.journalisation;   // EF-06 (alarme)

    // Chaque action du flux decoule d'une exigence
    dependency from ProcessusGererSituationUrgence::surveillerEntreeSSI        to interfaceSSI;
    dependency from ProcessusGererSituationUrgence::recevoirSignalSSI          to interfaceSSI;
    dependency from ProcessusGererSituationUrgence::deverrouillerIssuesSecours to delaiOuvertureUrgence;
    dependency from ProcessusGererSituationUrgence::ouvrirPortesEvacuation     to situationUrgence;
    dependency from ProcessusGererSituationUrgence::passerEnSecuritePositive   to securiteEvacuation;
    dependency from ProcessusGererSituationUrgence::journaliserDebutUrgence    to journalisation;
    dependency from ProcessusGererSituationUrgence::journaliserFinUrgence      to journalisation;
}
