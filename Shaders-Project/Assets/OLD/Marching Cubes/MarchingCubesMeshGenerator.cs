using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

[RequireComponent(typeof(MeshRenderer), typeof(MeshFilter))]
public class MarchingCubesMeshGenerator : MonoBehaviour
{
    private MeshFilter meshFilter;
    private Mesh mesh;

    [SerializeField] private InteractableVertice verticePrefab;
    [SerializeField] private InteractableVertice[] currentBox;
    [SerializeField] private InteractableVertice[,,] interactableVertices;
    [SerializeField] private List<Vector3> verticies = new List<Vector3>();
    [SerializeField] private List<int> triangles = new List<int>();
    [SerializeField] private int triangulationNumber;
    [SerializeField] private int gridSize;

    private void Start()
    {
        meshFilter = GetComponent<MeshFilter>();
        mesh = new Mesh();

        GenerateInteractableVerticies();
    }

    private void GenerateInteractableVerticies()
    {
        currentBox = new InteractableVertice[8];

        interactableVertices = new InteractableVertice[gridSize, gridSize, gridSize];

        for (int x = 0; x < gridSize; x++)
        {
            for (int y = 0; y < gridSize; y++)
            {
                for (int z = 0; z < gridSize; z++)
                {
                    Vector3 position = new Vector3(x, y, z) + transform.position * 0.5f;

                    interactableVertices[x, y, z] = Instantiate(verticePrefab, position,
                Quaternion.identity, transform);
                    interactableVertices[x, y, z].Initialize(this);
                }
            }
        }


        StartCoroutine(MarchRoutine());
    }

    private IEnumerator MarchRoutine()
    {
        WaitForSeconds delay = new WaitForSeconds(0.01f);

        for (int z = 0; z < gridSize - 1; z++)
        {
            for (int y = 0; y < gridSize - 1; y++)
            {
                for (int x = 0; x < gridSize - 1; x++)
                {
                    currentBox = GetInteractableVertice(x, y, z);
                    UpdateMesh(GetTriNumber());

                    yield return delay;
                }
            }
        }

        RecalculateMesh();
    }

    private InteractableVertice[] GetInteractableVertice(int x, int y, int z)
    {
        return new[] {
        interactableVertices[x, y, z+1],
        interactableVertices[x+1, y, z+1],
        interactableVertices[x+1, y, z],
        interactableVertices[x, y, z],
        interactableVertices[x, y+1, z+1],
        interactableVertices[x+1, y+1, z+1],
        interactableVertices[x+1, y+1, z],
        interactableVertices[x, y+1, z],
      };
    }
    private int GetTriNumber()
    {
        int number = 0;

        for (int i = 0; i < currentBox.Length; i++)
        {
            if (currentBox[i].IsActive == true)
            {
                switch (i)
                {
                    case 0: number += 1; break;
                    case 1: number += 2; break;
                    case 2: number += 4; break;
                    case 3: number += 8; break;
                    case 4: number += 16; break;
                    case 5: number += 32; break;
                    case 6: number += 64; break;
                    case 7: number += 128; break;
                }
            }

        }

        return number;
    }

    private void UpdateMesh(int number)
    {
        int[] triangulation = TriangleFinder.GetTriangles(number);

        foreach (var edgeIndex in triangulation)
        {
            int indexA = TriangleFinder.EdgeConnections[edgeIndex][0];
            int indexB = TriangleFinder.EdgeConnections[edgeIndex][1];

            Vector3 vertexPosition = (currentBox[indexA].transform.position
                + currentBox[indexB].transform.position) / 2;

            verticies.Add(vertexPosition);
            AddTriangle();
        }
    }

    private void RecalculateMesh()
    {
        mesh.SetVertices(verticies);
        mesh.SetTriangles(triangles, 0);
        mesh.RecalculateNormals();
        meshFilter.mesh = mesh;
    }

    private void AddTriangle()
    {
        int triangleIndex = triangles.Count;
        triangles.Add(triangleIndex);
    }

    private void OnDrawGizmos()
    {
        if (currentBox == null)
            return;

        for (int i = 0; i < currentBox.Length; i++)
        {
            Gizmos.color = Color.green;
            Gizmos.DrawWireSphere(currentBox[i].transform.position, 0.15f);
        }
    }
}
