using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class showText : MonoBehaviour
{
    public TMP_Text nameText;
    public TMP_Text infoText;
    public TextAsset jsonFile;
    public string carname;
    private DataContainer brands;

    // Start is called before the first frame update
    void Start() {
        nameText = nameText.GetComponent<TMP_Text>();
        infoText = infoText.GetComponent<TMP_Text>();   
    }

    public void onTarget() {
         brands = readJSON();
         switch (carname) {
            case "volkswagen":
                nameText.text = brands.volkswagen.name;
                infoText.text = "Gründung: " + brands.volkswagen.year + "\n" + "Sitz: " + brands.volkswagen.country + "\n" + "Auto-Modell: " + brands.volkswagen.car;
                break;
            case "toyota":
                nameText.text = brands.toyota.name;
                infoText.text = "Gründung: " + brands.toyota.year + "\n" + "Sitz: " + brands.toyota.country + "\n" + "Auto-Modell: " + brands.toyota.car;
                break;
            case "porsche":
                nameText.text = brands.porsche.name;
                infoText.text = "Gründung: " + brands.porsche.year + "\n" + "Sitz: " + brands.porsche.country + "\n" + "Auto-Modell: " + brands.porsche.car;
                break;
            case "audi":
                nameText.text = brands.audi.name;
                infoText.text = "Gründung: " + brands.audi.year + "\n" + "Sitz: " + brands.audi.country + "\n" + "Auto-Modell: " + brands.audi.car;
                break;
            case "bmw":
                nameText.text = brands.bmw.name;
                infoText.text = "Gründung: " + brands.bmw.year + "\n" + "Sitz: " + brands.bmw.country + "\n" + "Auto-Modell: " + brands.bmw.car;
                break;
         }
         
    }

    DataContainer readJSON() {
        return JsonUtility.FromJson<DataContainer>(jsonFile.text);    
    }
}
