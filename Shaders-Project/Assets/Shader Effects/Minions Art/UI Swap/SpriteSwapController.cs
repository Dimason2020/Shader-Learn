using UnityEngine;
using UnityEngine.UI;

public class SpriteSwapController : MonoBehaviour
{
    [SerializeField] private Material spriteSwapMaterial;
    [SerializeField] private Image icon;
    [SerializeField] private Sprite mainIcon;
    [SerializeField] private Texture swapIcon;

    [SerializeField] private bool flipHorizontal;
    [SerializeField] private bool flipVertical;
    [SerializeField] private bool horizontalGradient;
    [SerializeField] private bool verticalGradient;

    private void Start()
    {
        icon.material = spriteSwapMaterial;
        icon.sprite = mainIcon;
        spriteSwapMaterial.SetTexture("_MainTex2", swapIcon);
    }

    private void Update()
    {
        
    }
}
