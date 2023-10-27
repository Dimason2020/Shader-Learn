using UnityEngine;

public class SnowBrush : MonoBehaviour
{
    [SerializeField] private CustomRenderTexture renderTexture;
    [SerializeField] private Material drawMaterial;
    private Camera mainCamera;

    private static readonly int _DrawPosition = Shader.PropertyToID("_DrawPosition");

    private void Start()
    {
        renderTexture.Initialize();
        mainCamera = Camera.main;
    }

    private void Update()
    {
        DrawInput();
    }

    private void DrawInput()
    {
        if(Input.GetMouseButton(0))
        {
            Ray ray = mainCamera.ScreenPointToRay(Input.mousePosition);

            if(Physics.Raycast(ray, out RaycastHit raycastHit))
            {
                Vector2 hit = raycastHit.textureCoord;
                drawMaterial.SetVector(_DrawPosition, hit);
            }
        }
    }
}
