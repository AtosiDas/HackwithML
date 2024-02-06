//SPDX-License-Identifier: GPL-3.0
pragma solidity  >= 0.7.0 < 0.9.0;

contract Demo{
    address[] patientsArray;
    address[] AmbulancesArray;
    string[] HospitalsArray;
    struct Patients{
        string name;
        address nominee;
        bool ambulanceRequired;
        string location;
    }
    mapping(address => Patients) public patientsDetails;
    struct Ambulances{
        uint carNumber;
        uint rating;
        bool available;
        string location;
        string hospital;
    }
    mapping(address => Ambulances) public AmbulanceDetails;
    struct Datas{
        string name;
        uint BP;
        uint sugar;
        uint heartBeat;
    }
    mapping(address => Datas) PatientsData;
    event Emergency(address patient, string location, uint time);
    event AllocateAmbulance(string name, uint carNumber);
    function Registration_Patient(string memory _name, address _nominee) public {
        for(uint i = 0; i < patientsArray.length; i++){
            require(patientsArray[i] != msg.sender,"You are already registered!");
        }
        patientsArray.push(msg.sender);
        Patients memory newPatient;
        newPatient.name = _name;
        newPatient.nominee = _nominee;
        patientsDetails[msg.sender] = newPatient;
    }

    function Registration_Ambulance(uint _carNumber, string memory _location, string memory _hospital) public {
        for(uint i = 0; i < AmbulancesArray.length; i++){
            require(AmbulancesArray[i] != msg.sender,"You are already registered for ambulance!");
        }
        Ambulances memory newDetails;
        AmbulancesArray.push(msg.sender);
        newDetails.carNumber = _carNumber;
        newDetails.available = true;
        newDetails.rating = 0;
        newDetails.location = _location;
        newDetails.hospital = _hospital;
        AmbulanceDetails[msg.sender] = newDetails;
        HospitalsArray.push(_hospital);  
    }

    function updateNominee(address _newNominee) public {
        for(uint i = 0; i < patientsArray.length; i++){
            if(patientsArray[i] == msg.sender){
                patientsDetails[patientsArray[i]].nominee = _newNominee;
            }
        }
    }

    function updateLocation(string memory _location) public {
        for(uint i = 0; i < AmbulancesArray.length; i++){
            if(AmbulancesArray[i] == msg.sender){
                AmbulanceDetails[msg.sender].location = _location;
            }
        }
    }

    function callForAmbulance(string memory _location) public returns(uint _carNumber){
        bool info;
        for(uint i = 0; i < patientsArray.length; i++){
            if(patientsArray[i] == msg.sender){
                info = true;
            }
        }
        require(info == true, "You did not register yet.");
        require(patientsDetails[msg.sender].ambulanceRequired == false);
        patientsDetails[msg.sender].ambulanceRequired = true;
        patientsDetails[msg.sender].location = _location;
        emit Emergency(msg.sender, _location, block.timestamp);
        for(uint i = 0; i < AmbulancesArray.length; i++){
            if(AmbulanceDetails[AmbulancesArray[i]].available == true){
                AmbulanceDetails[AmbulancesArray[i]].available = false;
                emit AllocateAmbulance(patientsDetails[msg.sender].name,AmbulanceDetails[AmbulancesArray[i]].carNumber);
                return AmbulanceDetails[AmbulancesArray[i]].carNumber;
            }
        }
    }
    
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
   
}