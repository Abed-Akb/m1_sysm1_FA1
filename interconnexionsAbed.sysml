
package Interconnexion {

    // Definition des ports de communication

    port def PortNFC;
    port def PortDonnees;
    port def PortCommande;
    port def PortSurveillance;
    port def PortSupervision;

    // Definitions des composants

    part def SmartphoneNFC {
        port nfc : PortNFC;
    }

    part def LecteurNFC {
        port nfc : PortNFC;
        port donnees : PortDonnees;
    }

    part def ControleurLocal {
        port lecteur : PortDonnees;
        port autorisations : PortDonnees;
        port porte : PortCommande;
        port capteurs : PortSurveillance;
        port analyse : PortDonnees;
    }

    part def BaseAutorisations {
        port controleur : PortDonnees;
    }

    part def PorteAutomatique {
        port commande : PortCommande;
    }

    part def CapteursPorte {
        port mesures : PortSurveillance;
    }

    part def ModuleAnalyse {
        port controleur : PortDonnees;
        port supervision : PortSupervision;
    }

    part def InterfaceSupervision {
        port analyse : PortSupervision;
    }

    // Architecture et interconnexion du systeme

    part def ATMD_PreviAccess {

        part smartphone : SmartphoneNFC;
        part lecteurNFC : LecteurNFC;
        part controleur : ControleurLocal;
        part baseAutorisations : BaseAutorisations;
        part porte : PorteAutomatique;
        part capteurs : CapteursPorte;
        part analyse : ModuleAnalyse;
        part supervision : InterfaceSupervision;

        // Connexion NFC

        connect smartphone.nfc to lecteurNFC.nfc;

        // Transmission des donnees du lecteur au controleur

        connect lecteurNFC.donnees to controleur.lecteur;

        // Verification des autorisations

        connect controleur.autorisations
            to baseAutorisations.controleur;

        // Commande de la porte

        connect controleur.porte to porte.commande;

        // Transmission des mesures des capteurs

        connect capteurs.mesures to controleur.capteurs;

        // Transmission des donnees au module d'analyse

        connect controleur.analyse to analyse.controleur;

        // Transmission des alertes a l'interface

        connect analyse.supervision to supervision.analyse;
    }
}
