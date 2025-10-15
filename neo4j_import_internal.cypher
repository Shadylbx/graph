
// Create constraints
CREATE CONSTRAINT unique_node IF NOT EXISTS FOR (n:Policy) REQUIRE n.id IS UNIQUE;

// Load nodes
LOAD CSV WITH HEADERS FROM 'file:///neo4j_nodes_internal.csv' AS row
CREATE (n {id: row[':ID'], name: row.name, type: row.type, status: row.status, color: row.color})
SET n:Policy;

// Load relationships
LOAD CSV WITH HEADERS FROM 'file:///neo4j_edges_internal.csv' AS row
MATCH (a {id: row[':START_ID']}), (b {id: row[':END_ID']})
CREATE (a)-[:RELATION {type: row[':TYPE'], label: row.relation_label}]->(b);
