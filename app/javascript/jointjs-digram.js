import * as joint from "@joint/core";
export function createGraphFromJson(jsonData) {
    // Initialize JointJS Paper
    //console.log(jsonData);
    const graph = new joint.dia.Graph();
    const paper = new joint.dia.Paper({
        el: document.getElementById('diagram-container'),
        model: graph,
        width: 1200,
        height: 800,
        gridSize: 20,
        drawGrid: true,
        interactive: { linkMove: false, nodeMovable: true },
        background: { color: '#f8f9fa' }
    });

    // Create graph from JSON
    createGraph(graph, null, jsonData);
    //adjust canvas graph according to node in canvas
    adjustCanvasWidth(graph, paper);
    //adjust same node border stroke color based on test_plan_id => data: { description: `Details about ${data.name}`, node_id: data.id }
    applySameBorderColorForSameText(graph);
}

function createGraph(graph, parent, data, position = { x: 50, y: 50 }, level = 0) {
    //let node = new joint.shapes.standard.Rectangle();
    //parent ? "#D1FAE5" : "#D3E3FC"

    let nodeWidth = 250; // Fixed width
    let textMaxWidth = nodeWidth - 5; // Leave padding

    // Measure text height dynamically
    let words = data.name.split(" ");
    let wrappedText = "";
    let line = "";
    let lines = 1;
    let context = document.createElement("canvas").getContext("2d");
    context.font = "14px Arial"; // Match font

    words.forEach(word => {
        let testLine = line + word + " ";
        let metrics = context.measureText(testLine);
        if (metrics.width > textMaxWidth) {
            wrappedText += line + "\n";
            line = word + " ";
            lines++;
        } else {
            line = testLine;
        }
    });
    wrappedText += line.trim();

    let nodeHeight = Math.max(50, lines * 20 + 20); // Dynamic height

    let node = new joint.shapes.standard.Rectangle({
        //position: { x, y },
        size: { width: nodeWidth, height: nodeHeight },
        attrs: {
            body: {
                fill: parent ? "#fff" : "#fff", // Different color for parent vs child D3E3FC
                stroke: parent ? "#1D4ED8" : "#1D4ED8",
                strokeWidth: 2,
                rx: 10,
                ry: 10
            },
            label: {
                text: data.name,
                fill: "#1E293B",
                fontSize: 14,
                fontWeight: "bold",
                textAnchor: "middle",
                textVerticalAnchor: "middle",
                textWrap: {
                    width: textMaxWidth,
                    height: nodeHeight - 20,
                    ellipsis: true
                }
            }
        },
        data: { description: `Details about ${data.name}`, node_id: data.id }
    });

    node.position(position.x + level * 200, position.y);
    //node.resize(180, 40);
    // node.attr({
    //     //body: { fill: '#3498db', stroke: '#2980b9', rx: 5, ry: 5 },
    //     label: { text: data.name, fill: 'white', fontSize: 14 }
    // });
    node.addTo(graph);

    // Create link from parent to child
    if (parent) {
        let link = new joint.shapes.standard.Link();
        link.source(parent);
        link.target(node);
        link.addTo(graph);
        link.attr({
            line: {
                stroke: "#1D4ED8",
                strokeWidth: 2,
                targetMarker: { type: "path", d: "M 10 -5 0 0 10 5 Z", fill: "#1D4ED8" }
            }
        });
    }

    // Recursively process children
    let childY = position.y;
    data.children.forEach((child, index) => {
        createGraph(graph, node, child, { x: position.x + 100, y: childY + index * 100 }, level + 1);
    });
}

function adjustCanvasWidth(graph, paper) {
    let elements = graph.getElements();
    let maxX = 0;

    elements.forEach(element => {
        let bbox = element.getBBox();
        maxX = Math.max(maxX, bbox.x + bbox.width);
    });

    let newWidth = maxX + 100; // Add some padding
    document.getElementById("diagram-container").style.width = `${newWidth}px`;
    paper.setDimensions(newWidth, 800);
}

function applySameBorderColorForSameText(graph) {
    let textColorMap = {}; // Store text -> color mapping
    let usedColors = ["#FF5733", "#33FF57", "#3357FF", "#FF33A1", "#FFD700", "#1D4ED8", "#f9ebea", "#af7ac5", "#1a5276", "#FFD700", "#8A2BE2", "#00CED1",
        "#FF4500", "#DC143C", "#008000", "#0000FF", "#800080", "#FF1493", "#FF8C00",
        "#40E0D0", "#6495ED", "#D2691E", "#C71585", "#DAA520", "#ADFF2F", "#8B008B",
        "#FF6347", "#20B2AA", "#7B68EE", "#BA55D3", "#CD5C5C", "#00FA9A", "#4682B4",
        "#A52A2A", "#5F9EA0", "#DDA0DD", "#F4A460", "#FF00FF", "#32CD32", "#9932CC"]; // Sample colors

    // Get all elements (nodes)
    let elements = graph.getElements();

    elements.forEach(node => {
        //let text = node.attr("label/text"); // Extract node text
        let test_node = node.get('data').node_id;

        // Assign a color if text appears for the first time
        if (!textColorMap[test_node]) {
            textColorMap[test_node] = usedColors[Object.keys(textColorMap).length % usedColors.length];
        }
        // Apply the same color to all nodes with the same text
        node.attr("body/stroke", textColorMap[test_node]);
    });
}