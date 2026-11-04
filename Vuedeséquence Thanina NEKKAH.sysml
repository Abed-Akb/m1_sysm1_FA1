
package ATMD_PreviAccess_Sequence {

    // Definition des participants
    part def Smartphone;
    part def LecteurNFC;
    part def ControleurATMD;
    part def SystemeAutorisations;
    part def Porte;

    // Cas d'utilisation : accederAvecSmartphoneNFC
    // Scenario : acces autorise

    occurrence def SequenceAccesSmartphoneNFC {

        // 1. Smartphone
        part smartphone : Smartphone {
            event occurrence presenterBadge;
            then event occurrence recevoirConfirmation;
        }

        // 2. Lecteur NFC
        part lecteur : LecteurNFC {
            event occurrence recevoirBadge;
            then event occurrence envoyerIdentifiant;
        }

        // 3. Controleur ATMD
        part controleur : ControleurATMD {
            event occurrence recevoirIdentifiant;
            then event occurrence transmettreIdentifiant;
            then event occurrence recevoirDecision;
            then event occurrence commanderOuverture;
        }

        // 4. Systeme d'autorisations
        part autorisations : SystemeAutorisations {
            event occurrence recevoirIdentifiant;
            then event occurrence verifierIdentifiant;
            then event occurrence envoyerDecision;
        }

        // 5. Porte
        part porte : Porte {
            event occurrence recevoirCommandeOuverture;
            then event occurrence confirmerEtatOuvert;
        }

        // MESSAGE 1 : Smartphone -> Lecteur NFC
        message presentationBadge
            from smartphone.presenterBadge
            to lecteur.recevoirBadge;

        // MESSAGE 2 : Lecteur NFC -> Controleur
        message transmissionIdentifiant
            from lecteur.envoyerIdentifiant
            to controleur.recevoirIdentifiant;

        // MESSAGE 3 : Controleur -> Autorisations
        message demandeAutorisation
            from controleur.transmettreIdentifiant
            to autorisations.recevoirIdentifiant;

        // Verification interne des autorisations
        succession autorisations.recevoirIdentifiant
            then autorisations.verifierIdentifiant;

        succession autorisations.verifierIdentifiant
            then autorisations.envoyerDecision;

        // MESSAGE 4 : Autorisations -> Controleur
        message resultatAutorisation
            from autorisations.envoyerDecision
            to controleur.recevoirDecision;

        // MESSAGE 5 : Controleur -> Porte
        message commandeOuverture
            from controleur.commanderOuverture
            to porte.recevoirCommandeOuverture;

        // MESSAGE 6 : Porte -> Smartphone
        message confirmationOuverture
            from porte.confirmerEtatOuvert
            to smartphone.recevoirConfirmation;

        // ORDRE CHRONOLOGIQUE DES MESSAGES

        first presentationBadge
            then transmissionIdentifiant;

        succession transmissionIdentifiant
            then demandeAutorisation;

        succession demandeAutorisation
            then resultatAutorisation;

        succession resultatAutorisation
            then commandeOuverture;

        succession commandeOuverture
            then confirmationOuverture;
    }

    occurrence sequenceAccesSmartphoneNFC :
        SequenceAccesSmartphoneNFC;
}
