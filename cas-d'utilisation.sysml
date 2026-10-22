package ATMD {

    package parts {

        part def Utilisateur;
        part def Gestionnaire;
        part def AgentSecurite;
        part def TechnicienMaintenance;
        part def SystemeSecuriteIncendie;

        part def ATMDPreviAccess;
    }

    package useCases {

        private import ATMD::parts::*;

        actor utilisateur : Utilisateur;
        actor gestionnaire : Gestionnaire;
        actor agentSecurite : AgentSecurite;
        actor technicien : TechnicienMaintenance;
        actor securiteIncendie : SystemeSecuriteIncendie;

        use case accederAvecBadgeNFC {
            ref actor utilisateur;
        }

        use case gererAutorisations {
            ref actor gestionnaire;
        }

        use case consulterEvenementsAcces {
            ref actor agentSecurite;
        }

        use case consulterEtatPortes {
            ref actor technicien;
        }

        use case consulterAlertesMaintenance {
            ref actor technicien;
        }

        use case gererSituationUrgence {
            ref actor securiteIncendie;
        }
    }
}