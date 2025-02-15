using TMPro;
using System;
using UnityEngine;

public class DemoUI : MonoBehaviour
{
    [SerializeField] private TextMeshProUGUI _selectedDateText;

    public void OnPickDateButtonClicked()
    {
        NativeDatePickerManager.Instance.PickDate(OnDateSelected);
    }

    private void OnDateSelected(DateTime date)
    {
        _selectedDateText.text = date.ToString("dd/MM/yyyy");
    }
}
