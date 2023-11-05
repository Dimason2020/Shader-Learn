using System;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

[RequireComponent(typeof(MeshRenderer), typeof(MeshFilter))]
public class MarchingCubesMeshGenerator : MonoBehaviour
{
    private MeshRenderer meshRenderer;
    private MeshFilter meshFilter;
    private Mesh mesh;

    [SerializeField] private InteractableVertice verticePrefab;
    [SerializeField] private List<InteractableVertice> interactableVertices;
    [SerializeField] private List<Vector3> verticies = new List<Vector3>();
    [SerializeField] private int triangulationNumber;
    private List<int> triangles = new List<int>();
    [SerializeField] private int gridSize;

    private void Start()
    {
        meshRenderer = GetComponent<MeshRenderer>();
        meshFilter = GetComponent<MeshFilter>();
        mesh = new Mesh();

        ClearMesh();
        GenerateInteractableVerticies();
    }

    private void GenerateInteractableVerticies()
    {
        for (int i = 0; i < TriangleFinder.CubeVertices.Length; i++)
        {
            InteractableVertice vertice = Instantiate(verticePrefab, transform.position 
                + TriangleFinder.CubeVertices[i],
                Quaternion.identity, transform);
            vertice.Initialize(this, i);
            interactableVertices.Add(vertice);
        }
    }

    public void CalculateTriangulationNumber(bool adding, int value)
    {
        if (adding)
            triangulationNumber += value;
        else
            triangulationNumber -= value;

        UpdateMesh();
    }


    private void UpdateMesh()
    {
        int[] triangulation = TriangleFinder.GetTriangles(triangulationNumber);

        ClearMesh();

        foreach (var edgeIndex in triangulation)
        {
            int indexA = TriangleFinder.EdgeConnections[edgeIndex][0];
            int indexB = TriangleFinder.EdgeConnections[edgeIndex][1];

            Vector3 vertexPosition = (TriangleFinder.CubeVertices[indexA]
                + TriangleFinder.CubeVertices[indexB]) / 2;

            verticies.Add(vertexPosition);
        }

        for (int i = 0; i < verticies.Count; i += 3)
        {
            AddTriangle();
        }
        
        mesh.vertices = verticies.ToArray();
        mesh.triangles = triangles.ToArray();
        mesh.RecalculateNormals();
        meshFilter.mesh = mesh;
    }

    private void AddTriangle()
    {
        int triangleIndex = triangles.Count;
        triangles.Add(triangleIndex);
        triangles.Add(triangleIndex + 1);
        triangles.Add(triangleIndex + 2);
    }


    private void ApplyToGrid(Action<int, int, int> action, int sizeOffset = 0)
    {
        for (int x = 0; x < gridSize + sizeOffset; x++)
        {
            for (int y = 0; y < gridSize + sizeOffset; y++)
            {
                for (int z = 0; z < gridSize + sizeOffset; z++)
                {
                    action?.Invoke(x, y, z);
                }
            }
        }
    }

    private void ClearMesh()
    {
        verticies.Clear();
        triangles.Clear();
        mesh.Clear();
    }

    private void OnDrawGizmos()
    {
        if (verticies == null)
            return;

        for (int i = 0; i < verticies.Count; i++)
        {
            Gizmos.color = Color.gray;
            Gizmos.DrawSphere(verticies[i], 0.05f);
        }
    }
}
