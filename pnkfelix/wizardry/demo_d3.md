---
layout: center
---

# Symmetric Graph Layout Example

<div id="graph" class="w-full h-80 border border-gray-200 rounded-md"></div>

<script setup>
import { onMounted, onUnmounted } from 'vue'
import * as d3 from 'd3'  // Already available in Slidev!

onMounted(() => {
  // Sample graph data - a small symmetric graph (a cube)
  const nodes = [
    { id: 1, label: 'Need' },
    { id: 2, label: 'Spec' },
    { id: 3, label: 'Impl' },
    { id: 4, label: 'Test' },
    { id: 5, label: 'Ship' },
  ]
  
  const links = [
    { source: 1, target: 2 },
    { source: 2, target: 3 },
    { source: 3, target: 4 },
    { source: 4, target: 5 },
    { source: 5, target: 1 }
  ]
  
  // Set up container
  const container = document.getElementById('graph')
  const width = container.clientWidth
  const height = container.clientHeight
  
  // Create SVG container
  const svg = d3.select('#graph')
    .append('svg')
    .attr('width', width)
    .attr('height', height)

  // Create a group for the graph
  const g = svg.append('g')
    .attr('transform', `translate(${width/2}, ${height/2})`)
  
  // Set up force simulation with specific forces for a symmetric layout
  const simulation = d3.forceSimulation(nodes)
    .force('link', d3.forceLink(links).id(d => d.id).distance(70))
    .force('charge', d3.forceManyBody().strength(-200))
    .force('radial', d3.forceRadial(100))
    
  // Draw links as lines
  const link = g.append('g')
    .selectAll('line')
    .data(links)
    .enter()
    .append('line')
    .attr('stroke', '#999')
    .attr('stroke-opacity', 0.8)
    .attr('stroke-width', 2)
	
  // Draw nodes as circles with labels
  const node = g.append('g')
    .selectAll('.node')
    .data(nodes)
    .enter()
    .append('g')
    .attr('class', 'node')
    .call(d3.drag()
      .on('start', dragStarted)
      .on('drag', dragging)
      .on('end', dragEnded))
  
  // Add circles for nodes
  node.append('circle')
    .attr('r', 30)
    .attr('fill', '#69b3a2')
    .attr('stroke', '#fff')
    .attr('stroke-width', 2)
  
  // Add text labels
  node.append('text')
    .attr('text-anchor', 'middle')
    .attr('dominant-baseline', 'central')
    .attr('fill', 'white')
    .style('font-weight', 'bold')
    .text(d => d.label)
  
  // Update positions on each tick of the simulation
  simulation.on('tick', () => {
    link
      .attr('x1', d => d.source.x)
      .attr('y1', d => d.source.y)
      .attr('x2', d => d.target.x)
      .attr('y2', d => d.target.y)
    
    node.attr('transform', d => `translate(${d.x}, ${d.y})`)
  })
  
  // Let simulation run for a while to find a good layout
  // then stop it for better performance
  setTimeout(() => {
    simulation.stop()
  }, 2000)
  
  // Drag functions
  function dragStarted(event, d) {
    if (!event.active) simulation.alphaTarget(0.3).restart()
    d.fx = d.x
    d.fy = d.y
  }
  
  function dragging(event, d) {
    d.fx = event.x
    d.fy = event.y
  }
  
  function dragEnded(event, d) {
    if (!event.active) simulation.alphaTarget(0)
    d.fx = null
    d.fy = null
  }
})

// Cleanup function
onUnmounted(() => {
  // Find and stop any running simulations
  d3.select('#graph').selectAll('*').remove()
})
</script>

