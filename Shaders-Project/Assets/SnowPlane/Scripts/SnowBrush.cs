using UnityEngine;

public class SnowBrush : MonoBehaviour
{
    [SerializeField] private CustomRenderTexture renderTexture;
    [SerializeField] private Material drawMaterial;
    [SerializeField] private Transform[] tires;
    private Transform currentTire;
    private int tireIndex;

    private Camera mainCamera;

    private static readonly int _DrawPosition = Shader.PropertyToID("_DrawPosition");
    private static readonly int _DrawAngle = Shader.PropertyToID("_DrawAngle");

    private void Start()
    {
        renderTexture.Initialize();
        mainCamera = Camera.main;
    }

    private void Update()
    {
        DrawTires();
        DrawInput();
    }

    private void DrawTires()
    {
        currentTire = tires[tireIndex++ % tires.Length];

        Ray ray = new Ray(currentTire.position, Vector3.down);
        if (Physics.Raycast(ray, out RaycastHit raycastHit))
        {
            Vector2 hit = raycastHit.textureCoord;
            float angle = currentTire.eulerAngles.y;

            drawMaterial.SetVector(_DrawPosition, hit);
            drawMaterial.SetFloat(_DrawAngle, angle * Mathf.Deg2Rad);
        }
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
                drawMaterial.SetFloat(_DrawAngle, 90 * Mathf.Deg2Rad);
            }
        }
    }
}
