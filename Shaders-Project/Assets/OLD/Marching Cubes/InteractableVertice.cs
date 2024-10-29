using System;
using UnityEngine;

[RequireComponent(typeof(MeshRenderer), typeof(MeshFilter))]
public class InteractableVertice : MonoBehaviour
{
    private MarchingCubesMeshGenerator generator;
    private MeshRenderer meshRenderer;
    private MeshFilter meshFilter;
    public int Index;
    [SerializeField] private bool isActive = false;
    public bool IsActive => isActive;

    private void Awake()
    {
        meshRenderer = GetComponent<MeshRenderer>();
        meshFilter = GetComponent<MeshFilter>();

        meshRenderer.material.color = Color.black;
    }

    public void Initialize(MarchingCubesMeshGenerator _generator)
    {
        generator = _generator;

        int random = UnityEngine.Random.Range(-1, 2);
        isActive = random <= 0 ? false : true;

        meshRenderer.material.color = isActive == true
            ? Color.white
            : Color.black;
    }
}
