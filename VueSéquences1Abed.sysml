
package AccesNFC_Sequence {

    part def Utilisateur;
    part def SmartphoneNFC;
    part def LecteurNFC;
    part def ControleurLocal;
    part def BaseAutorisations;
    part def PorteAutomatique;

    occurrence def sequenceAccesNFC {

        part utilisateur : Utilisateur {
            event occurrence presenterBadge;
            event occurrence recevoirConfirmation;
            event occurrence recevoirRefus;
        }

        part smartphone : SmartphoneNFC {
            event occurrence recevoirPresentation;
            event occurrence transmettreIdentifiant;
        }

        part lecteur : LecteurNFC {
            event occurrence recevoirBadge;
            event occurrence transmettreDonnees;
        }

        part controleur : ControleurLocal {
            event occurrence recevoirIdentifiant;
            event occurrence demanderVerification;
            event occurrence recevoirDecision;
            event occurrence envoyerCommandeOuverture;
            event occurrence envoyerRefus;
        }

        part base : BaseAutorisations {
            event occurrence recevoirDemande;
            event occurrence verifierDroits;
            event occurrence retournerDecision;
        }

        part porte : PorteAutomatique {
            event occurrence recevoirCommande;
            event occurrence ouvrirPorte;
        }

        message 'Présenter le badge NFC' from utilisateur.presenterBadge
            to smartphone.recevoirPresentation;

        message 'Transmettre l\'identifiant' from smartphone.transmettreIdentifiant
            to lecteur.recevoirBadge;

        message 'Envoyer les données du badge' from lecteur.transmettreDonnees
            to controleur.recevoirIdentifiant;

        message 'Demander la vérification des droits' from controleur.demanderVerification
            to base.recevoirDemande;

        message 'Retourner la décision' from base.retournerDecision
            to controleur.recevoirDecision;

        message 'Commander l\'ouverture' from controleur.envoyerCommandeOuverture
            to porte.recevoirCommande;

        message 'Confirmer l\'accès' from porte.ouvrirPorte
            to utilisateur.recevoirConfirmation;


        first 'Présenter le badge NFC' then 'Transmettre l\'identifiant';
        first 'Transmettre l\'identifiant' then 'Envoyer les données du badge';
        first 'Envoyer les données du badge' then 'Demander la vérification des droits';
        first 'Demander la vérification des droits' then 'Retourner la décision';
        first 'Retourner la décision' then 'Commander l\'ouverture';
        first 'Commander l\'ouverture' then 'Confirmer l\'accès';
        first 'Retourner la décision' then 'Signaler le refus d\'accès';
    }
}
