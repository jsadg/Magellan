package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"github.com/gin-gonic/gin"
	"github.com/hyperledger/fabric-sdk-go/pkg/core/config"
	"github.com/hyperledger/fabric-sdk-go/pkg/gateway"
)

var loggedInUser string


type User struct {
	VAID       string `json:"vaid"`
	Password string `json:"password"`
	Role     string `json:"role"`
}

var users = map[string]User{
	"111111111-11":   {"111111111-11", "password", "veteran"},
	"111111111-12":   {"111111111-11", "password", "veteran"},
	"va1":         {"va1", "password", "va"},
	"insurance1":  {"insurance1", "password", "insurance"},
	"healthcare1": {"healthcare1", "password", "healthcare"},
}


type ClaimInfo struct {
	ClaimID           string     `json:"ClaimId"`
	DisabilityPercent int        `json:"DisabilityPercent"`
	Status            string     `json:"Status"`
	UserHealthKey		string	`json:"UserHealthKey"`			//Used to access the UserHealth in the PDC
	UserInfoKey		string `json:"UserInfoKey"` //Used to access the UserInfo in the PDC
	VeteranBenefitsID string 	`json:"VeteranBenefitsId"` //Format of 123456789-12

}

//UserInfo struct holds basic information of the claimee
type UserInfo struct {
	Address           string `json:"Address"`     //Format of "123 Main St, Kingston, New York 12401",
	DateOfBirth       string `json:"DateOfBirth"` //Format of DD/MM/YYYY
	Email             string `json:"Email"`
	Name              string `json:"Name"`
	Phone             string `json:"Phone"`
	SocialSecurity    string `json:"SocialSecurity"`    //Format of 123-12-1234
}

//UserHealth struct holds health information of the claimee
type UserHealth struct {
	HealthConditions string `json:"HealthConditions"` //List of health conditions
	HealthRecords    string `json:"HealthRecords"`    //Link to the health record file in the database
	ServiceHistory   string `json:"ServiceHistory"`   //List of their service history
	Verified         bool     `json:"Verified"`         //If the health information is verified or not

}

//Claim struct contains UserHealth and UserInfo as well as assigns a claimID and status
type Claim struct {
	ClaimInfo		ClaimInfo	`json:"ClaimInfo"`
	UserHealth      UserHealth `json:"UserHealth"`
	UserInfo        UserInfo   `json:"UserInfo"`
}

func main() {

	//Initialize Veteran
	walletPath := "./wallets/Veteranwallet"
	cpPath := "./connection-profiles/Veteranconnection-profile.yaml"
	identityName := "peer1-veteran"
	mspID := "VeteranMSP"
	certificatePath := "/var/hyperledger/veteran/peer1/msp/signcerts/cert.pem"
	privateKeyDir := "/var/hyperledger/veteran/peer1/msp/keystore"


	wallet, err := createIdentity(walletPath, identityName, mspID, certificatePath, privateKeyDir)
	if err != nil {
		log.Fatalf("Error creating identity: %v", err)
	}

	//Initialize Healthcare
	walletPath = "./wallets/Healthcarewallet"
	cpPath = "./connection-profiles/Healthcareconnection-profile.yaml"
	identityName = "peer1-healthcare"
	mspID = "HealthcareMSP"
	certificatePath = "/var/hyperledger/healthcare/peer1/msp/signcerts/cert.pem"
	privateKeyDir = "/var/hyperledger/healthcare/peer1/msp/keystore"

	wallet, err = createIdentity(walletPath, identityName, mspID, certificatePath, privateKeyDir)
	if err != nil {
		log.Fatalf("Error creating identity: %v", err)
	}

	//Initialize Insurance
	walletPath = "./wallets/Insurancewallet"
	cpPath = "./connection-profiles/Insuranceconnection-profile.yaml"
	identityName = "peer1-insurance"
	mspID = "InsuranceMSP"
	certificatePath = "/var/hyperledger/insurance/peer1/msp/signcerts/cert.pem"
	privateKeyDir = "/var/hyperledger/insurance/peer1/msp/keystore"

	wallet, err = createIdentity(walletPath, identityName, mspID, certificatePath, privateKeyDir)
	if err != nil {
		log.Fatalf("Error creating identity: %v", err)
	}

	//Initialize VA
	walletPath = "./wallets/VAwallet"
	cpPath = "./connection-profiles/VAconnection-profile.yaml"
	identityName = "peer1-va"
	mspID = "VAMSP"
	certificatePath = "/var/hyperledger/va/peer1/msp/signcerts/cert.pem"
	privateKeyDir = "/var/hyperledger/va/peer1/msp/keystore"

	wallet, err = createIdentity(walletPath, identityName, mspID, certificatePath, privateKeyDir)
	if err != nil {
		log.Fatalf("Error creating identity: %v", err)
	}

	contract, err := connectToNetwork(wallet, identityName, cpPath)
	if err != nil {
		log.Fatalf("Error connecting to network: %v", err)
	}

	r := gin.Default()
	r.SetTrustedProxies(nil)

	
	r.LoadHTMLGlob("./pages/*.html")

	r.GET("/", func(c *gin.Context) {
		c.Redirect(http.StatusFound, "/login")
	})


	// Route for the login page
	r.GET("/login", func(c *gin.Context) {
		c.HTML(http.StatusOK, "login.html", nil)
	})

	// Route for the submit claim page
	r.GET("/veteran_dashboard/submitClaim", func(c *gin.Context) {
		c.HTML(http.StatusOK, "submitClaim.html", nil)
	})

	// Route for the veteran dashboard page
	r.GET("/veteran_dashboard", func(c *gin.Context) {
		c.HTML(http.StatusOK, "veteran_dashboard.html", nil)
	})

	// Route for the VA dashboard page
	r.GET("/va_dashboard", func(c *gin.Context) {
		c.HTML(http.StatusOK, "va_dashboard.html", nil)
	})

	// Route for the healthcare dashboard page
	r.GET("/healthcare_dashboard", func(c *gin.Context) {
		c.HTML(http.StatusOK, "healthcare_dashboard.html", nil)
	})

	// Route for the insurance dashboard page
	r.GET("/insurance_dashboard", func(c *gin.Context) {
		c.HTML(http.StatusOK, "insurance_dashboard.html", nil)
	})


    //Submit Claim Action
	r.POST("/veteran_dashboard/submitClaim", func(c *gin.Context) {
		var claim Claim
		if err := c.ShouldBindJSON(&claim); err != nil {
			c.JSON(400, gin.H{"error": "Invalid input data"})
			return
		}

		err := submitClaimToChaincode(contract, claim)
		if err != nil {
			c.JSON(500, gin.H{"error": err.Error()})
			return
		}

		c.JSON(200, gin.H{"message": "Claim submitted successfully"})
	})

	r.GET("/veteran_dashboard/viewClaim", func(c *gin.Context) {
		c.HTML(http.StatusOK, "viewClaim.html", nil)
		if loggedInUser == "" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "You must log in first"})
			return
		}

		// Fetch claim data based on the logged-in Veteran Benefits ID
		claim, err := viewClaimFromBlockchain(contract, loggedInUser)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}

		// Return claim information in response
		c.JSON(http.StatusOK, gin.H{
			"ClaimInfo":  claim.ClaimInfo,
			"UserInfo":   claim.UserInfo,
			"UserHealth": claim.UserHealth,
		})
	})
	

    // Get Pending Claims
    r.GET("/api/pendingClaims", func(c *gin.Context) {
		c.HTML(http.StatusOK, "pendingClaims.html", nil)
        claims, err := getPendingClaimsFromChaincode(contract)
        if err != nil {
            c.JSON(500, gin.H{"error": err.Error()})
            return
        }

        c.JSON(200, claims)
    })



	r.POST("/login", func(c *gin.Context) {
		var user User
		if err := c.ShouldBindJSON(&user); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request body"})
			return
		}
	
		fmt.Printf("Received login request: VAID=%s, Password=%s, Role=%s\n", user.VAID, user.Password, user.Role)
	
		// Check credentials
		if storedUser, exists := users[user.VAID]; exists && storedUser.Password == user.Password {
			fmt.Printf("Credentials matched for: %s\n", user.VAID)
	
			loggedInUser = user.VAID
	
			var walletPath, cpPath, identityName, mspID string
	
			// Set the wallet paths and connection profiles based on role
			switch storedUser.Role {
			case "veteran":
				walletPath = "./wallets/veteranWallet"
				cpPath = "./connection-profiles/Veteranconnection-profile.yaml"
				identityName = "peer1-veteran"
				mspID = "VeteranMSP"
			case "va":
				walletPath = "./wallets/vaWallet"
				cpPath = "./connection-profiles/VAconnection-profile.yaml"
				identityName = "peer1-va"
				mspID = "VAMSP"
			case "insurance":
				walletPath = "./wallets/insuranceWallet"
				cpPath = "./connection-profiles/Insuranceconnection-profile.yaml"
				identityName = "peer1-insurance"
				mspID = "InsuranceMSP"
			case "healthcare":
				walletPath = "./wallets/healthcareWallet"
				cpPath = "./connection-profiles/Healthcareconnection-profile.yaml"
				identityName = "peer1-healthcare"
				mspID = "HealthcareMSP"
			default:
				c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid role"})
				return
			}
	
			// Create wallet and connect to network
			wallet, err := createIdentity(walletPath, identityName, mspID,
				fmt.Sprintf("/var/hyperledger/%s/peer1/msp/signcerts/cert.pem", storedUser.Role),
				fmt.Sprintf("/var/hyperledger/%s/peer1/msp/keystore", storedUser.Role))
			if err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": fmt.Sprintf("Error creating identity: %v", err)})
				return
			}
	
			contract, err := connectToNetwork(wallet, identityName, cpPath)
			if err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": fmt.Sprintf("Error connecting to network: %v", err)})
				return
			}
	
			c.Set("contract", contract)
	
			// Send a success message with the role information
			c.JSON(http.StatusOK, gin.H{"message": "Login successful", "role": storedUser.Role})
	
			// Redirect after sending the success message
			switch storedUser.Role {
			case "veteran":
				c.Redirect(http.StatusFound, "/veteran_dashboard")
			case "va":
				c.Redirect(http.StatusFound, "/va_dashboard")
			case "insurance":
				c.Redirect(http.StatusFound, "/insurance_dashboard")
			case "healthcare":
				c.Redirect(http.StatusFound, "/healthcare_dashboard")
			}
		} else {
			fmt.Printf("Invalid credentials for: %s\n", user.VAID)
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
		}
	})
	
	
	
	
	
	
	
	r.Run(":8080")
	
}

func submitClaimToChaincode(contract *gateway.Contract, claim Claim) error {
	args := []string{
		claim.UserInfo.Address,
		claim.UserInfo.DateOfBirth,
		claim.UserInfo.Email,
		claim.UserInfo.Name,
		claim.UserInfo.Phone,
		claim.UserInfo.SocialSecurity,
		claim.ClaimInfo.VeteranBenefitsID,
		claim.UserHealth.HealthConditions,
		claim.UserHealth.HealthRecords,
		claim.UserHealth.ServiceHistory,
	}

	_, err := contract.SubmitTransaction("SubmitClaim", args...)
	if err != nil {
		return fmt.Errorf("failed to submit claim to chaincode: %v", err)
	}
	return nil
}

func getPendingClaimsFromChaincode(contract *gateway.Contract) ([]*Claim, error) {
	results, err := contract.EvaluateTransaction("GetPendingClaims")
	if err != nil {
		return nil, fmt.Errorf("failed to query claims: %v", err)
	}
	var claims []*Claim
	err = json.Unmarshal(results, &claims)
	if err != nil {
		return nil, fmt.Errorf("failed to unmarshal query result: %v", err)
	}
	return claims, nil
}

func viewClaimFromBlockchain(contract *gateway.Contract, veteranBenefitsID string) (Claim, error) {
	result, err := contract.EvaluateTransaction("viewClaim", veteranBenefitsID)
	if err != nil {
		return Claim{}, fmt.Errorf("failed to query claim from blockchain: %v", err)
	}

	// Map the result to the Claim struct
	var claim Claim
	err = json.Unmarshal(result, &claim)
	if err != nil {
		return Claim{}, fmt.Errorf("failed to unmarshal claim data: %v", err)
	}

	// Return the retrieved claim
	return claim, nil
}


func createIdentity(walletPath, identityName, mspID, certificatePath, privateKeyDir string) (*gateway.Wallet, error) {
	// Initialize the wallet
	wallet, err := gateway.NewFileSystemWallet(walletPath)
	if err != nil {
		return nil, fmt.Errorf("failed to create wallet: %w", err)
	}

	// Read the certificate
	cert, err := os.ReadFile(certificatePath)
	if err != nil {
		return nil, fmt.Errorf("failed to read certificate: %w", err)
	}

	// Locate the private key
	var privateKeyPath string
	err = filepath.Walk(privateKeyDir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		// Check if the file ends with "sk"
		if !info.IsDir() && filepath.Base(path)[len(filepath.Base(path))-2:] == "sk" {
			privateKeyPath = path
		}
		return nil
	})
	if err != nil {
		return nil, fmt.Errorf("failed to locate private key: %w", err)
	}
	if privateKeyPath == "" {
		return nil, fmt.Errorf("no private key ending with 'sk' found in directory: %s", privateKeyDir)
	}

	// Read the private key
	key, err := os.ReadFile(privateKeyPath)
	if err != nil {
		return nil, fmt.Errorf("failed to read private key: %w", err)
	}

	// Create the identity
	identity := gateway.NewX509Identity(mspID, string(cert), string(key))

	// Add identity to wallet
	err = wallet.Put(identityName, identity)
	if err != nil {
		return nil, fmt.Errorf("failed to add identity to wallet: %w", err)
	}
	log.Printf("Identity %s successfully added to the wallet", identityName)

	return wallet, nil
}

func connectToNetwork(wallet *gateway.Wallet, identityName, cpPath string) (*gateway.Contract, error) {
	gw, err := gateway.Connect(
		gateway.WithConfig(config.FromFile(cpPath)),
		gateway.WithIdentity(wallet, identityName),
	)
	if err != nil {
		return nil, fmt.Errorf("failed to connect to gateway: %w", err)
	}

	network, err := gw.GetNetwork("orgschannel")
	if err != nil {
		gw.Close()
		return nil, fmt.Errorf("failed to get network: %w", err)
	}

	contract := network.GetContract("networkcc")

	return contract, nil
}
