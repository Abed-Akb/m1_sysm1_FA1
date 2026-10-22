package ATMD_Contexte {

    package parts {
        part def ATMDPreviAccess;
        part def Utilisateur;
        part def Gestionnaire;
        part def AgentSecurite;
        part def TechnicienMaintenance;
        part def SmartphoneNFC;
        part def PorteAutomatique;
        part def ReseauElectrique;
        part def ReseauInternet;
        part def SystemeSecuriteIncendie;
    }

    private import ATMD_Contexte::parts::*;

    part def Contexte {

        part atmd : ATMDPreviAccess;

        part utilisateur : Utilisateur[*];
        part smartphone : SmartphoneNFC[*];
        part gestionnaire : Gestionnaire;
        part agentSecurite : AgentSecurite;
        part technicien : TechnicienMaintenance;

        part porte : PorteAutomatique[*];
        part alimentation : ReseauElectrique;
        part internet : ReseauInternet;
        part securiteIncendie : SystemeSecuriteIncendie;


        flow demandeAcces from utilisateur to atmd;
        flow presenteBadge from smartphone to atmd;
        flow commandeOuverture from atmd to porte;


        flow gereAutorisations from gestionnaire to atmd;
        flow synchroniseDroits from internet to atmd;

        

        flow consulteEvenements from agentSecurite to atmd;

    

        flow transmetMesures from porte to atmd;
        flow transmetAlertes from atmd to technicien;


        flow alimente from alimentation to atmd;
        flow signaleUrgence from securiteIncendie to atmd;
    }

    
    part contexte : Contexte;
}