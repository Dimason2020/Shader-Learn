using UnityEngine;

public class MeshGenerator : MonoBehaviour
{
    public SquareGrid squareGrid;

    public void GenerateMesh(int[,] map, float squareSize)
    {
        squareGrid = new SquareGrid(map, squareSize);
    }

    void TriangulateSquare(Square square)
    {

    }

    void MeshFromPoints()
    {

    }

    public class SquareGrid
    {
        public Square[,] squares;

        public SquareGrid(int[,] map, float size)
        {
            int nodeCountX = map.GetLength(0);
            int nodeCountY = map.GetLength(1);

            float mapWidth = nodeCountX * size;
            float mapHeight = nodeCountY * size;

            ControllNode[,] nodes = new ControllNode[nodeCountX, nodeCountY];

            for (int x = 0; x < nodeCountX; x++)
            {
                for (int y = 0; y < nodeCountY; y++)
                {
                    Vector3 pos = new Vector3(-mapWidth / 2 + x * size + size / 2,
                        0,
                        -mapHeight / 2 + y * size + size / 2);

                    nodes[x, y] = new ControllNode(pos, map[x, y] == 1, size);
                }
            }

            squares = new Square[nodeCountX - 1, nodeCountY - 1];


            for (int x = 0; x < nodeCountX - 1; x++)
            {
                for (int y = 0; y < nodeCountY - 1; y++)
                {
                    squares[x, y] = new Square(nodes[x, y + 1], nodes[x + 1, y + 1],
                        nodes[x + 1, y], nodes[x, y]);
                }
            }
        }
    }

    public class Square
    {
        public ControllNode topLeft, topRight, bottomRight, bottomLeft;
        public Node centerTop, centerRight, centerBottom, centerLeft;
        public int configuration;

        public Square(ControllNode topLeft, ControllNode topRight, ControllNode bottomRight, ControllNode bottomLeft)
        {
            this.topLeft = topLeft;
            this.topRight = topRight;
            this.bottomRight = bottomRight;
            this.bottomLeft = bottomLeft;

            this.centerTop = topLeft.right;
            this.centerRight = bottomRight.above;
            this.centerBottom = bottomLeft.right;
            this.centerLeft = bottomLeft.above;

            if (topLeft.active) configuration += 8;
            if(topRight.active) configuration += 4;
            if(bottomRight.active) configuration += 2;
            if(bottomLeft.active) configuration += 1;

        }
    }
    public class Node
    {
        public Vector3 position;
        public int vertexIndex = -1;

        public Node(Vector3 _position)
        {
            position = _position;
        }
    }

    public class ControllNode : Node
    {
        public bool active;
        public Node above, right;

        public ControllNode(Vector3 _position, bool _active, float _squareSize) : base(_position)
        {
            active = _active;

            above = new Node(position + Vector3.forward * _squareSize / 2f);
            right = new Node(position + Vector3.right * _squareSize / 2f);
        }
    }

    private void OnDrawGizmos()
    {
        if (squareGrid != null)
        {
            for (int x = 0; x < squareGrid.squares.GetLength(0); x++)
            {
                for (int y = 0; y < squareGrid.squares.GetLength(1); y++)
                {
                    Gizmos.color = (squareGrid.squares[x, y].topLeft.active) ? Color.black : Color.white;
                    Gizmos.DrawCube(squareGrid.squares[x, y].topLeft.position, Vector3.one * 0.4f);

                    Gizmos.color = (squareGrid.squares[x, y].topRight.active) ? Color.black : Color.white;
                    Gizmos.DrawCube(squareGrid.squares[x, y].topRight.position, Vector3.one * 0.4f);

                    Gizmos.color = (squareGrid.squares[x, y].bottomRight.active) ? Color.black : Color.white;
                    Gizmos.DrawCube(squareGrid.squares[x, y].bottomRight.position, Vector3.one * 0.4f);

                    Gizmos.color = (squareGrid.squares[x, y].bottomLeft.active) ? Color.black : Color.white;
                    Gizmos.DrawCube(squareGrid.squares[x, y].bottomLeft.position, Vector3.one * 0.4f);


                    Gizmos.color = Color.gray;
                    Gizmos.DrawCube(squareGrid.squares[x, y].centerTop.position, Vector3.one * 0.15f);
                    Gizmos.DrawCube(squareGrid.squares[x, y].centerLeft.position, Vector3.one * 0.15f);
                    Gizmos.DrawCube(squareGrid.squares[x, y].centerRight.position, Vector3.one * 0.15f);
                    Gizmos.DrawCube(squareGrid.squares[x, y].centerBottom.position, Vector3.one * 0.15f);
                }
            }
        }
    }
}
