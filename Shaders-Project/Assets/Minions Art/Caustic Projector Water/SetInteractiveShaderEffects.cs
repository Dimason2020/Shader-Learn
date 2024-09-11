using UnityEngine;

public class SetInteractiveShaderEffects : MonoBehaviour
{
    [SerializeField] private RenderTexture renderTexture;
    [SerializeField] private Transform target;
    [SerializeField] private Camera camera;
    [SerializeField] private Material material;

    void Awake()
    {
        Shader.SetGlobalTexture("_GlobalEffectRT", renderTexture);
        Shader.SetGlobalFloat("_OrthographicCamSize", camera.orthographicSize);
    }

    private void Update()
    {
        transform.position = new Vector3(target.transform.position.x, transform.position.y, target.transform.position.z);
        Shader.SetGlobalVector("_Position", target.position);
    }
}