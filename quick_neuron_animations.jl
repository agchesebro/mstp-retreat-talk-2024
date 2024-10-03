# Super lazy code but also I'm making this for a retreat talk so looking for something fast not efficient or super polished

using Neuroblox
using OrdinaryDiffEq
using GLMakie

# Create Izhikevich neuron block and simulate
@named izh = IzhikevichNeuron(η=0.25, θ=50.0)
g = MetaDiGraph()
add_blox!(g, izh)
@named sys = system_from_graph(g)
prob = ODEProblem(sys, [], (0, 100.0))
sol = solve(prob, Tsit5(), saveat = 0.5)
data = Array(sol)

# Honestly there's probably a better way of doing this but quick version of animation based on https://docs.makie.org/v0.21/explanations/animation
points = Observable(Point2f[(0, 0); (0.5, data[1, 1])]) # you can crash GLMakie if you don't give lines at least 2 points
fig, ax = lines(points, color = :blue, linewidth = 2)
limits!(ax, 0, 100, -50, 50)

frames = 1.0:0.5:100

record(fig, "single_neuron_animation.gif", frames; 
                        framerate = 30) do frame
    new_point = Point2f(frame, data[1, Int(frame * 2)])
    points[] = push!(points[], new_point)
end

# Make multiple interacting neurons
@named izh1 = IzhikevichNeuron(θ=50)
@named izh2 = IzhikevichNeuron(η=0.14, θ=50)
g = MetaDiGraph()
add_blox!.(Ref(g), [izh1, izh2])
add_edge!(g, 1, 2, Dict(:weight => 0.5, :connection_rule => "basic"))
add_edge!(g, 2, 1, Dict(:weight => 1.0, :connection_rule => "basic"))
@named sys = system_from_graph(g)
prob = ODEProblem(sys, [], (0, 100.0))
sol = solve(prob, Tsit5(), saveat=0.5)
data = Array(sol)

# Once again lazy but gets it done
points1 = Observable(Point2f[(0, 0); (0.5, data[1, 1])]) # you can crash GLMakie if you don't give lines at least 2 points
points2 = Observable(Point2f[(0, 0); (0.5, data[5, 1])]) # you can crash GLMakie if you don't give lines at least 2 points
fig, ax = lines(points1, color = :blue, linewidth = 2)
lines!(points2, color = :red, linewidth = 2)
limits!(ax, 0, 100, -50, 50)

frames = 1.0:0.5:100

record(fig, "double_neuron_animation.gif", frames; 
                        framerate = 30) do frame
    new_point1 = Point2f(frame, data[1, Int(frame * 2)])
    points1[] = push!(points1[], new_point1)
    new_point2 = Point2f(frame, data[5, Int(frame * 2)])
    points2[] = push!(points2[], new_point2)
end