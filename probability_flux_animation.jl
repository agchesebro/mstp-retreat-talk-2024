using GLMakie

# Simple cosine probability flux animation
# Most of this comes from modifying the example at https://docs.makie.org/v0.21/explanations/animation
time = Observable(0.0)
xs = range(0, 2π, length=40)
ys_1 = @lift(0.5 .* cos.(xs .- $time) .+ 0.5)
fig = lines(xs, ys_1, color = :blue, linewidth = 4,
    axis = (title = @lift("t = $(round($time, digits = 1))"),))
framerate = 30
timestamps = range(0, 2π, step=1/framerate)
record(fig, "smooth_probability.gif", timestamps;
        framerate = framerate) do t
    time[] = t
end

# Now make a "chaotic" version
time = Observable(0.0)
xs = range(0, 10π, length=300)
ys_1 = @lift(0.5 .* cos.(0.4 .* (xs .- $time)) .* sin.(1.5 .* (xs .- $time)) .* sin.(0.25 .* (xs .- $time)) .+ 0.5)
fig = lines(xs, ys_1, color = :blue, linewidth = 2,
    axis = (title = @lift("t = $(round($time, digits = 1))"),))
framerate = 15
timestamps = range(0, 3π, step=1/framerate)
record(fig, "unsmooth_probability.gif", timestamps;
        framerate = framerate) do t
    time[] = t
end