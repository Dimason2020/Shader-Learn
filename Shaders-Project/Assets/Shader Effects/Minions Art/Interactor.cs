using UnityEngine;

[ExecuteAlways]
public class Interactor : MonoBehaviour
{
    [SerializeField] float radius;
    [SerializeField] private Material[] materials;

    // Update is called once per frame
    void Update()
    {
        if(materials.Length > 0)
        {
            foreach (var material in materials)
            {
                material.SetFloat("_Radius", radius);
                material.SetVector("_Position", transform.position);
            }
        }
    }
}