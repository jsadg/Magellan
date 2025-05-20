package main

import (
	"encoding/json"
	"fmt"
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
	"log"
)

var LastClaimID = 9


//SmartContract provides functions for managing an Asset
type SmartContract struct {
	contractapi.Contract
}

type ClaimInfo struct {
	ClaimID           string     `json:"ClaimId"`
	DisabilityPercent int        `json:"DisabilityPercent"`
	Status            string     `json:"Status"`
	UserHealthKey		string	`json:"UserHealthKey"`
	UserInfoKey		string `json:"UserInfoKey"`
	VeteranBenefitsID string 	`json:"VeteranBenefitsId"`
}

type UserInfo struct {
	Address           string `json:"Address"`
	DateOfBirth       string `json:"DateOfBirth"`
	Email             string `json:"Email"`
	Name              string `json:"Name"`
	Phone             string `json:"Phone"`
	SocialSecurity    string `json:"SocialSecurity"` 
}

type UserHealth struct {
	HealthConditions string `json:"HealthConditions"`
	HealthRecords    string `json:"HealthRecords"`
	ServiceHistory   string `json:"ServiceHistory"`
	Verified         bool     `json:"Verified"`
}

//Claim struct contains UserHealth and UserInfo as well as assigns a claimID and status
type Claim struct {
	ClaimInfo		ClaimInfo	`json:"ClaimInfo"`
	UserHealth      UserHealth `json:"UserHealth"`
	UserInfo        UserInfo   `json:"UserInfo"`
}


//InitLedger adds a base set of claims to the ledger
func (s *SmartContract) InitLedger(ctx contractapi.TransactionContextInterface) error{
    log.Println("Initializing ledger...")
	claims := []Claim{
		{	
			ClaimInfo: ClaimInfo{
				ClaimID:           "1",
				DisabilityPercent: 0,
				Status:            "Pending",
				UserHealthKey:	"UserHealth_1",
				UserInfoKey: 		"UserInfo_1",
				VeteranBenefitsID: "111111111-11",
			},
			UserHealth: UserHealth{
				HealthConditions: "PTSD",
				HealthRecords:    "Record1",
				ServiceHistory:   "Tour in Iraq",
				Verified:         false,
			},
			UserInfo: UserInfo{
				Address:           "123 Main St, Kingston, New York 12401",
				DateOfBirth:       "12/12/1965",
				Email:             "user1@example.com",
				Name:              "Jane Smith",
				Phone:             "123-456-7890",
				SocialSecurity:    "111-11-1111",
			},
		},
		{
			ClaimInfo: ClaimInfo{
				ClaimID:           "2",
				DisabilityPercent: 20,
				Status:            "Approved",
				UserHealthKey:	   "UserHealth_2",
				UserInfoKey:      "UserInfo_2",
				VeteranBenefitsID: "111111111-12",
			},
			UserHealth: UserHealth{
				HealthConditions: "PTSD",
				HealthRecords:    "Record2",
				ServiceHistory:   "Korean War",
				Verified:         true,
			},
			UserInfo: UserInfo{
				Address:           "456 Elm St, Kingston, New York 12401",
				DateOfBirth:       "05/04/1932",
				Email:             "user2@example.com",
				Name:              "John Doe",
				Phone:             "123-456-7891",
				SocialSecurity:    "111-11-1112",
			},
		},
		{
			ClaimInfo: ClaimInfo{
				ClaimID:           "3",
				DisabilityPercent: 20,
				Status:            "Pending",
				UserHealthKey:	   "UserHealth_3",
				UserInfoKey:      "UserInfo_3",
				VeteranBenefitsID: "111111111-13",
			},
			UserHealth: UserHealth{
				HealthConditions: "PTSD",
				HealthRecords:    "Record3",
				ServiceHistory:   "Korean War",
				Verified:         false,
			},
			UserInfo: UserInfo{
				Address:           "123 Elm St, Kingston, New York 12401",
				DateOfBirth:       "05/04/1927",
				Email:             "user2@example.com",
				Name:              "Mtich Scott",
				Phone:             "123-456-7891",
				SocialSecurity:    "111-11-1113",
			},
		},		
	}
	//Takes the UserHealth and UserInfo structs and converts them to JSON before adding them to their respective PDCs
	//The ClaimInfo is put in the public world state
	for _, claim := range claims {
		claimInfoJSON, err := json.Marshal(claim.ClaimInfo)
		if err != nil {
			return fmt.Errorf("failed to marshal claimInfo: %v", err)
		}
		err = ctx.GetStub().PutState(claim.ClaimInfo.VeteranBenefitsID, claimInfoJSON)
		if err != nil {
			return fmt.Errorf("failed to put claimInfo in world state: %v", err)
		}

		//Puts healthinfo into the userHealth PDC
		//Doesn't error otherwise non-PDC orgs would fail
		userHealthJSON, err := json.Marshal(claim.UserHealth)
		if err != nil {
			return fmt.Errorf("failed to marshal userHealth: %v", err)
		}

		err = ctx.GetStub().PutPrivateData("HealthRecords", claim.ClaimInfo.UserHealthKey, userHealthJSON)

		//Puts healthinfo into the userInfo PDC
		//Doesn't error otherwise non-PDC orgs would fail
		userInfoJSON, err := json.Marshal(claim.UserInfo)
		if err != nil {
			return fmt.Errorf("failed to marshal userInfo: %v", err)
		}
		err = ctx.GetStub().PutPrivateData("UserInformation", claim.ClaimInfo.UserInfoKey, userInfoJSON)
	}
	return nil
}




//SubmitClaim creates a new claim and stores each part in its respective area
func (s *SmartContract) SubmitClaim(ctx contractapi.TransactionContextInterface, address string, dateOfBirth string, email string, name string, phone string, socialSecurity string, veteranBenefitsID string, healthConditions string, healthRecords string, serviceHistory string) error{
	//Check if claim already exists
	MSPID, err := ctx.GetClientIdentity().GetMSPID()
	if err != nil {
		return fmt.Errorf("failed to get MSPID: %v", err)
	}
	if MSPID != "VAMSP" {
		return fmt.Errorf("non-VA user")
	}
	existingClaim, err := ctx.GetStub().GetState(veteranBenefitsID)
	if err != nil {
		return fmt.Errorf("failed to get claim: %v", err)
	}
	if existingClaim != nil {
		return fmt.Errorf("claim already exists: %s", veteranBenefitsID)
	}
    
	var claimID = string(int(LastClaimID) + 1)
	LastClaimID=LastClaimID+1


	//Create ClaimInfo, UserInfo, and UserHealth
	claimInfo := ClaimInfo{
		ClaimID:           claimID,
		DisabilityPercent: 0,
		Status:            "Pending",
		UserHealthKey: "UserHealth_"+claimID,
		UserInfoKey: "UserInfo_"+claimID,
		VeteranBenefitsID: veteranBenefitsID,
	}
	userInfo := UserInfo{
		Address:           address,
		DateOfBirth:       dateOfBirth,
		Email:             email,
		Name:              name,
		Phone:             phone,
		SocialSecurity:    socialSecurity,
	}
	userHealth := UserHealth{
		HealthConditions: healthConditions,
		HealthRecords:    healthRecords,
		ServiceHistory:   serviceHistory,
		Verified:         false,
	}



	claimInfoJSON, err := json.Marshal(claimInfo)
	if err != nil {
		return fmt.Errorf("failed to marshal claimInfo: %v", err)
	}
	err = ctx.GetStub().PutState(claimInfo.VeteranBenefitsID, claimInfoJSON)
	if err != nil {
		return fmt.Errorf("failed to put claimInfo in world state: %v", err)
	}

	userHealthJSON, err := json.Marshal(userHealth)
	if err != nil {
		return fmt.Errorf("failed to marshal userHealth: %v", err)
	}
	err = ctx.GetStub().PutPrivateData("HealthRecords", claimInfo.UserHealthKey, userHealthJSON)
	if err != nil {
		return fmt.Errorf("failed to put userHealth in PDC: %v", err)
	}

	userInfoJSON, err := json.Marshal(userInfo)
	if err != nil {
		return fmt.Errorf("failed to marshal userInfo: %v", err)
	}
	err = ctx.GetStub().PutPrivateData("UserInformation", claimInfo.UserInfoKey, userInfoJSON)
	if err != nil {
		return fmt.Errorf("failed to put userInfo in PDC: %v", err)
	}
	return nil
}

func (s *SmartContract) GetPendingClaims(ctx contractapi.TransactionContextInterface) ([]*Claim, error) {
	queryString := `{"selector":{"Status":"Pending"}}`

	resultsIterator, err := ctx.GetStub().GetQueryResult(queryString)
	if err != nil {
		return nil, fmt.Errorf("failed to query claims: %v", err)
	}
	defer resultsIterator.Close()

	var claims []*Claim

	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()
		if err != nil {
			return nil, fmt.Errorf("failed to read query result: %v", err)
		}

		var claimInfo ClaimInfo
		err = json.Unmarshal(queryResponse.Value, &claimInfo)
		if err != nil {
			return nil, fmt.Errorf("failed to unmarshal ClaimInfo: %v", err)
		}

		claim := &Claim{
			ClaimInfo: claimInfo,
		}

		// Retrieve UserHealth from private data
		if claimInfo.UserHealthKey == "" {
			return nil, fmt.Errorf("UserHealthKey is empty for claim ID %s", claimInfo.ClaimID)
		}
		userHealthData, err := ctx.GetStub().GetPrivateData("HealthRecords", claimInfo.UserHealthKey)
		if err != nil {
			return nil, fmt.Errorf("failed to retrieve UserHealth: %v", err)
		}
		if userHealthData != nil {
			var userHealth UserHealth
			err = json.Unmarshal(userHealthData, &userHealth)
			if err != nil {
				return nil, fmt.Errorf("failed to unmarshal UserHealth: %v", err)
			}
			claim.UserHealth = userHealth
		}

		// Optional: Retrieve UserInfo as well
		if claimInfo.UserInfoKey != "" {
			userInfoData, err := ctx.GetStub().GetPrivateData("UserInformation", claimInfo.UserInfoKey)
			if err != nil {
				return nil, fmt.Errorf("failed to retrieve UserInfo: %v", err)
			}
			if userInfoData != nil {
				var userInfo UserInfo
				err = json.Unmarshal(userInfoData, &userInfo)
				if err != nil {
					return nil, fmt.Errorf("failed to unmarshal UserInfo: %v", err)
				}
				claim.UserInfo = userInfo
			}
		}

		claims = append(claims, claim)
	}

	return claims, nil
}





//Gets the claim information of the user to be used elsewhere
func (s *SmartContract) GetClaimInfo(ctx contractapi.TransactionContextInterface, veteranBenefitsID string) (*ClaimInfo, error) {
	//Retrieve the ClaimInfo from the ledger
	claimInfoJSON, err := ctx.GetStub().GetState(veteranBenefitsID)
	if err != nil {
		return nil, fmt.Errorf("failed to read claim: %v", err)
	}
	if claimInfoJSON == nil {
		return nil, fmt.Errorf("claim does not exist: %s", veteranBenefitsID)
	}

	//Unmarshal the JSON data into a ClaimInfo object
	var claimInfo ClaimInfo
	err = json.Unmarshal(claimInfoJSON, &claimInfo)
	if err != nil {
		return nil, fmt.Errorf("failed to unmarshal claim: %v", err)
	}
	return &claimInfo, nil
}


//Gets the information of the user to be used elsewhere
func (s *SmartContract) GetUserInfo(ctx contractapi.TransactionContextInterface, veteranBenefitsID string) (*UserInfo, error) {
	MSPID, err := ctx.GetClientIdentity().GetMSPID()
	if err != nil {
		return nil, fmt.Errorf("failed to get MSPID: %v", err)
	}
	if MSPID != "VAMSP" && MSPID != "InsuranceMSP" && MSPID != "VeteranMSP" && MSPID != "HealthcareMSP"{
		return nil, fmt.Errorf("non-major org user")
	}
	//Retrieve the ClaimInfo from the ledger
	claimInfoJSON, err := ctx.GetStub().GetState(veteranBenefitsID)

	if err != nil {
		return nil, fmt.Errorf("failed to read claim: %v", err)
	}
	if claimInfoJSON == nil {
		return nil, fmt.Errorf("claim does not exist: %s", veteranBenefitsID)
	}

	//Unmarshal the JSON data into the ClaimInfo
	var claimInfo ClaimInfo
	err = json.Unmarshal(claimInfoJSON, &claimInfo)
	if err != nil {
		return nil, fmt.Errorf("failed to unmarshal claim: %v", err)
	}
	//Access the UserInfo through the key stored in the ClaimInfo
	userInfoJSON, err := ctx.GetStub().GetPrivateData("UserInformation", claimInfo.UserInfoKey)
	if err != nil {
        return nil, fmt.Errorf("failed to get userInfo: %v", err)
    }
    if userInfoJSON == nil {
        return nil, fmt.Errorf("UserInfo not found for key %s", claimInfo.UserInfoKey)
    }

	//Unmarshal the JSON data into the UserInfo
    var userInfo UserInfo
    err = json.Unmarshal(userInfoJSON, &userInfo)
    if err != nil {
        return nil, fmt.Errorf("failed to unmarshal UserInfo: %v", err)
    }

    return &userInfo, nil
}

//Gets the information of the user to be used elsewhere
func (s *SmartContract) GetUserHealth(ctx contractapi.TransactionContextInterface, veteranBenefitsID string) (*UserHealth, error) {
	MSPID, err := ctx.GetClientIdentity().GetMSPID()
	if err != nil {
		return nil, fmt.Errorf("failed to get MSPID: %v", err)
	}
	//Only VA and Healthcare orgs are allowed to view health information
	if MSPID != "VAMSP" && MSPID != "HealthcareMSP" && MSPID != "VeteranMSP"{
		return nil, fmt.Errorf("non-VA, non-Veteran, and non-Healthcare user")
	}
	//Retrieve the ClaimInfo from the ledger
	claimInfoJSON, err := ctx.GetStub().GetState(veteranBenefitsID)
	if err != nil {
		return nil, fmt.Errorf("failed to read claim: %v", err)
	}
	if claimInfoJSON == nil {
		return nil, fmt.Errorf("claim does not exist: %s", veteranBenefitsID)
	}

	//Unmarshal the JSON data into the ClaimInfo
	var claimInfo ClaimInfo
	err = json.Unmarshal(claimInfoJSON, &claimInfo)
	if err != nil {
		return nil, fmt.Errorf("failed to unmarshal claim: %v", err)
	}

	fmt.Printf("Claim Info: %+v\n", claimInfo)

	//Access the UserHealth through the key stored in the ClaimInfo
	userHealthJSON, err := ctx.GetStub().GetPrivateData("HealthRecords", claimInfo.UserHealthKey)
	if err != nil {
        return nil, fmt.Errorf("failed to get UserHealth: %v", err)
    }
    if userHealthJSON == nil {
        return nil, fmt.Errorf("UserHealth not found for key %s", claimInfo.UserHealthKey)
    }

	//Unmarshal the JSON data into the UserHealth
    var userHealth UserHealth
    err = json.Unmarshal(userHealthJSON, &userHealth)
    if err != nil {
        return nil, fmt.Errorf("failed to unmarshal UserInfo: %v", err)
    }

    return &userHealth, nil
}

//Used to get a veteran's claim
func (s *SmartContract) GetClaim(ctx contractapi.TransactionContextInterface, veteranBenefitsID string) (*Claim, error) {
	// Get the public ClaimInfo from state
	claimInfo, err := s.GetClaimInfo(ctx, veteranBenefitsID)
	if err != nil {
		return nil, err
	}

	// Get UserInfo from private data
	userInfo, err := s.GetUserInfo(ctx, veteranBenefitsID)
	if err != nil {
		return nil, err
	}

	// Get UserHealth from private data
	userHealth, err := s.GetUserHealth(ctx, veteranBenefitsID)
	if err != nil {
		return nil, err
	}

	// Construct the full Claim
	claim := &Claim{
		ClaimInfo:  *claimInfo,
		UserInfo:   *userInfo,
		UserHealth: *userHealth,
	}

	return claim, nil
}


//ApproveClaim updates the ClaimStatus and Disability Percent for a claim in the blockchain ledger
func (s *SmartContract) ApproveClaim(ctx contractapi.TransactionContextInterface, veteranBenefitsID string, newStatus string, newDisabilityPercent int) error{
	MSPID, err := ctx.GetClientIdentity().GetMSPID()
	if err != nil {
		return fmt.Errorf("failed to get MSPID: %v", err)
	}
	//Only VA org should be allowed to approve claim
	if MSPID != "VAMSP" {
		return fmt.Errorf("non-VA user")
	}
	//Retrieve the existing claim from the ledger
	claimInfoJSON, err := ctx.GetStub().GetState(veteranBenefitsID)
	if err != nil {
		return fmt.Errorf("failed to read claim: %v", err)
	}
	if claimInfoJSON == nil {
		return fmt.Errorf("claim does not exist: %s", veteranBenefitsID)
	}

	//Unmarshal the JSON data into ClaimInfo
	var claimInfo ClaimInfo
	err = json.Unmarshal(claimInfoJSON, &claimInfo)
	if err != nil {
		return fmt.Errorf("failed to unmarshal claim: %v", err)
	}

	//Update the claim fields with the new values
	claimInfo.Status = newStatus
	claimInfo.DisabilityPercent = newDisabilityPercent

	//Marshal the updated claim to JSON
	updatedClaimInfoJSON, err := json.Marshal(claimInfo)
	if err != nil {
		return fmt.Errorf("failed to marshal updated claim: %v", err)
	}

	//Put the updated claim back in the ledger
	err = ctx.GetStub().PutState(veteranBenefitsID, updatedClaimInfoJSON)
	if err != nil {
		return fmt.Errorf("failed to put updated claim in world state: %v", err)
	}

	return nil
}

//ApproveClaim updates the ClaimStatus and Disability Percent for a claim in the blockchain ledger
func (s *SmartContract) AppealClaim(ctx contractapi.TransactionContextInterface, veteranBenefitsID string) error{
	MSPID, err := ctx.GetClientIdentity().GetMSPID()
	if err != nil {
		return fmt.Errorf("failed to get MSPID: %v", err)
	}
	//Only VA org should be allowed to appeal claim
	if MSPID != "VAMSP" {
		return fmt.Errorf("non-VA user")
	}
	//Retrieve the existing claim from the ledger
	claimInfoJSON, err := ctx.GetStub().GetState(veteranBenefitsID)
	if err != nil {
		return fmt.Errorf("failed to read claim: %v", err)
	}
	if claimInfoJSON == nil {
		return fmt.Errorf("claim does not exist: %s", veteranBenefitsID)
	}

	//Unmarshal the JSON data into a Claim object
	var claimInfo ClaimInfo
	err = json.Unmarshal(claimInfoJSON, &claimInfo)
	if err != nil {
		return fmt.Errorf("failed to unmarshal claim: %v", err)
	}

	//Update the claim fields with the new values
	claimInfo.Status = "Appeal Pending"

	//Marshal the updated claim to JSON
	updatedClaimInfoJSON, err := json.Marshal(claimInfo)
	if err != nil {
		return fmt.Errorf("failed to marshal updated claim: %v", err)
	}

	//Put the updated claim back in the ledger
	err = ctx.GetStub().PutState(veteranBenefitsID, updatedClaimInfoJSON)
	if err != nil {
		return fmt.Errorf("failed to put updated claim in world state: %v", err)
	}

	return nil
}

//Gets the information of the user to be used elsewhere
func (s *SmartContract) ApproveUserHealth(ctx contractapi.TransactionContextInterface, veteranBenefitsID string) error {
	MSPID, err := ctx.GetClientIdentity().GetMSPID()
	if err != nil {
		return fmt.Errorf("failed to get MSPID: %v", err)
	}
	//Only VA org should be allowed to approve claim
	if MSPID != "HealthcareMSP" {
		return fmt.Errorf("non-Healthcare user")
	}
	//Retrieve the ClaimInfo from the ledger
	claimInfoJSON, err := ctx.GetStub().GetState(veteranBenefitsID)
	if err != nil {
		return fmt.Errorf("failed to read claim: %v", err)
	}
	if claimInfoJSON == nil {
		return fmt.Errorf("claim does not exist: %s", veteranBenefitsID)
	}

	//Unmarshal the JSON data into the ClaimInfo
	var claimInfo ClaimInfo
	err = json.Unmarshal(claimInfoJSON, &claimInfo)
	if err != nil {
		return fmt.Errorf("failed to unmarshal claim: %v", err)
	}
	//Access the UserHealth through the key stored in the ClaimInfo
	userHealthJSON, err := ctx.GetStub().GetPrivateData("HealthRecords", claimInfo.UserHealthKey)
	if err != nil {
        return fmt.Errorf("failed to get userHealth: %v", err)
    }
    if userHealthJSON == nil {
        return fmt.Errorf("UserHealth not found for key %s", claimInfo.UserHealthKey)
    }

	//Unmarshal the JSON data into the UserHealth
    var userHealth UserHealth
    err = json.Unmarshal(userHealthJSON, &userHealth)
    if err != nil {
        return fmt.Errorf("failed to unmarshal userHealth: %v", err)
    }

    userHealth.Verified = true

	updatedUserHealthJSON, err := json.Marshal(userHealth)
	if err != nil {
		return fmt.Errorf("failed to marshal updated health: %v", err)
	}

	err = ctx.GetStub().PutPrivateData("HealthRecords", claimInfo.UserHealthKey, updatedUserHealthJSON)
	if err != nil {
		return fmt.Errorf("failed to put updated health in world state: %v", err)
	}

	return nil

}


func main() {
	networkChaincode, err := contractapi.NewChaincode(&SmartContract{})
	if err != nil {
		log.Panicf("Error creating chaincode: %v", err)
	}

    err = networkChaincode.Start()
    if err != nil {
        log.Panicf("Error starting chaincode: %v", err)
    }
}
