
package Maintenance_Sequence {

    part def CapteursPorte;
    part def ControleurLocal;
    part def ModuleAnalyse;
    part def InterfaceSupervision;
    part def Technicien;

    occurrence def sequenceMaintenance {

        part capteurs : CapteursPorte {
            event occurrence transmettreMesures;
        }

        part controleur : ControleurLocal {
            event occurrence recevoirMesures;
            event occurrence transmettreDonnees;
        }

        part analyse : ModuleAnalyse {
            event occurrence recevoirDonnees;
            event occurrence envoyerAlerte;
        }

        part supervision : InterfaceSupervision {
            event occurrence recevoirAlerte;
            event occurrence notifierTechnicien;
            event occurrence recevoirDemandeConsultation;
            event occurrence afficherAlerte;
        }

        part technicien : Technicien {
            event occurrence recevoirNotification;
            event occurrence demanderConsultation;
            event occurrence consulterAlerte;
        }

        message transmettreMesures
            from capteurs.transmettreMesures
            to controleur.recevoirMesures;

        message transmettreDonnees
            from controleur.transmettreDonnees
            to analyse.recevoirDonnees;

        message envoyerAlerte
            from analyse.envoyerAlerte
            to supervision.recevoirAlerte;

        message notifierTechnicien
            from supervision.notifierTechnicien
            to technicien.recevoirNotification;

        message demanderConsultation
            from technicien.demanderConsultation
            to supervision.recevoirDemandeConsultation;

        message afficherAlerte
            from supervision.afficherAlerte
            to technicien.consulterAlerte;

        first transmettreMesures
            then transmettreDonnees
            then envoyerAlerte
            then notifierTechnicien
            then demanderConsultation
            then afficherAlerte;
    }
}
