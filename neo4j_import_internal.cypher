// --- Create unique constraint on IDs ---
CREATE CONSTRAINT unique_node IF NOT EXISTS FOR (n:Node) REQUIRE n.id IS UNIQUE;

// --- Load Nodes ---
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/<your_repo>/main/neo4j_nodes_internal.csv' AS row
CREATE (n:Node {
  id: row[":ID"],
  name: row.name,
  type: row.type,
  status: row.status,
  color: row.color
});

// --- Assign Labels by Type ---
MATCH (n:Node)
WHERE n.type = 'Master Policy' SET n:Policy;
MATCH (n:Node)
WHERE n.type = 'Policy' SET n:Policy;
MATCH (n:Node)
WHERE n.type = 'Standard' SET n:Standard;
MATCH (n:Node)
WHERE n.type = 'Procedure' SET n:Procedure;
MATCH (n:Node)
WHERE n.type = 'Specification' SET n:Specification;
MATCH (n:Node)
WHERE n.type = 'External Policy' SET n:External;
MATCH (n:Node)
WHERE n.status = 'Orphan' SET n:Orphan;

// --- Load Relationships ---
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/<your_repo>/main/neo4j_edges_internal.csv' AS row
MATCH (a:Node {id: row[":START_ID"]}), (b:Node {id: row[":END_ID"]})
CREATE (a)-[:RELATION {
  type: row[":TYPE"],
  label: row.relation_label
}]->(b);
